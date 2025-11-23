import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:zichat/storage/ai_config_storage.dart';

/// 统一的 AI 对话服务，支持 OpenAI / Gemini 两种 provider
class AiChatService {
  static String _basePromptCache = '';

  static Future<String> _getBasePrompt() async {
    if (_basePromptCache.isNotEmpty) return _basePromptCache;
    try {
      _basePromptCache = await rootBundle.loadString('sprompt.md');
    } catch (_) {
      _basePromptCache = '';
    }
    return _basePromptCache;
  }

  /// 调用 AI 接口，返回按反斜线分句后的多条回复
  static Future<List<String>> sendChat({
    required String chatId,
    required String userInput,
    List<Map<String, String>>? history,
  }) async {
    final config = await AiConfigStorage.loadGlobalConfig();
    if (config == null ||
        config.apiBaseUrl.trim().isEmpty ||
        config.apiKey.trim().isEmpty ||
        config.model.trim().isEmpty) {
      throw Exception('AI 配置不完整，请先在“我-设置-通用-AI 配置”中填写。');
    }

    final String basePrompt = await _getBasePrompt();
    final String contactPrompt =
        (await AiConfigStorage.loadContactPrompt(chatId)) ?? '';

    final buffer = StringBuffer();
    if (basePrompt.trim().isNotEmpty) {
      buffer.writeln(basePrompt.trim());
    }
    if (config.persona.trim().isNotEmpty) {
      buffer.writeln(config.persona.trim());
    }
    if (contactPrompt.trim().isNotEmpty) {
      buffer.writeln(contactPrompt.trim());
    }
    final String systemPrompt = buffer.toString().trim();

    final String raw;
    if (config.provider == 'gemini') {
      raw = await _callGemini(
        baseUrl: config.apiBaseUrl.trim(),
        apiKey: config.apiKey.trim(),
        model: config.model.trim(),
        systemPrompt: systemPrompt,
        userInput: userInput,
        history: history,
      );
    } else {
      raw = await _callOpenAiCompatible(
        baseUrl: config.apiBaseUrl.trim(),
        apiKey: config.apiKey.trim(),
        model: config.model.trim(),
        systemPrompt: systemPrompt,
        userInput: userInput,
        history: history,
      );
    }

    final List<String> parts = raw
        .split('\\')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty && raw.trim().isNotEmpty) {
      parts.add(raw.trim());
    }

    return parts;
  }

  static Uri _joinUri(String base, String path) {
    if (base.endsWith('/')) {
      return Uri.parse('$base$path');
    }
    return Uri.parse('$base/$path');
  }

  static Future<String> _callOpenAiCompatible({
    required String baseUrl,
    required String apiKey,
    required String model,
    required String systemPrompt,
    required String userInput,
    List<Map<String, String>>? history,
  }) async {
    final uri = _joinUri(baseUrl, 'v1/chat/completions');

    final List<Map<String, String>> messages = <Map<String, String>>[];

    if (systemPrompt.isNotEmpty) {
      messages.add(<String, String>{
        'role': 'system',
        'content': systemPrompt,
      });
    }

    if (history != null) {
      for (final Map<String, String> item in history) {
        final String content = (item['content'] ?? '').trim();
        if (content.isEmpty) continue;
        final String role = item['role'] ?? 'user';
        messages.add(<String, String>{
          'role': role,
          'content': content,
        });
      }
    }

    messages.add(<String, String>{
      'role': 'user',
      'content': userInput,
    });

    final body = <String, dynamic>{
      'model': model,
      'messages': messages,
      'temperature': 0.7,
    };

    final resp = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(body),
    );

    if (resp.statusCode != 200) {
      throw Exception('OpenAI 接口错误(${resp.statusCode}): ${resp.body}');
    }

    final Map<String, dynamic> data = jsonDecode(resp.body);
    final List<dynamic>? choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('OpenAI 返回内容为空');
    }
    final dynamic message = choices.first['message'];
    if (message is Map<String, dynamic>) {
      final dynamic content = message['content'];
      if (content is String) {
        return content;
      }
      return content.toString();
    }
    return message.toString();
  }

  static Future<String> _callGemini({
    required String baseUrl,
    required String apiKey,
    required String model,
    required String systemPrompt,
    required String userInput,
    List<Map<String, String>>? history,
  }) async {
    final String cleanedBase =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final uri = Uri.parse(
      '$cleanedBase/v1beta/models/$model:generateContent?key=$apiKey',
    );

    final StringBuffer buffer = StringBuffer();
    if (systemPrompt.isNotEmpty) {
      buffer.writeln(systemPrompt.trim());
      buffer.writeln();
    }

    if (history != null) {
      for (final Map<String, String> item in history) {
        final String content = (item['content'] ?? '').trim();
        if (content.isEmpty) continue;
        final String role = item['role'] ?? 'user';
        final String prefix = role == 'assistant' ? '朋友：' : '我：';
        buffer.writeln('$prefix$content');
      }
    }

    buffer.writeln('我：$userInput');
    final String promptText = buffer.toString().trim();

    final body = <String, dynamic>{
      'contents': [
        {
          'parts': [
            {
              'text': promptText,
            },
          ],
        },
      ],
    };

    final resp = await http.post(
      uri,
      headers: const <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (resp.statusCode != 200) {
      throw Exception('Gemini 接口错误(${resp.statusCode}): ${resp.body}');
    }

    final Map<String, dynamic> data = jsonDecode(resp.body);
    final List<dynamic>? candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('Gemini 返回内容为空');
    }

    final dynamic content = candidates.first['content'];
    if (content is Map<String, dynamic>) {
      final List<dynamic>? parts = content['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        throw Exception('Gemini 返回内容为空');
      }
      final buffer = StringBuffer();
      for (final dynamic p in parts) {
        if (p is Map<String, dynamic>) {
          final dynamic text = p['text'];
          if (text != null) {
            buffer.write(text.toString());
          }
        }
      }
      final result = buffer.toString();
      if (result.isEmpty) {
        throw Exception('Gemini 返回内容为空');
      }
      return result;
    }

    return content.toString();
  }
}
