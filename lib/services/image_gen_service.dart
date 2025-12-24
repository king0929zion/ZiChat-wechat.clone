import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:zichat/config/api_secrets.dart';
import 'package:zichat/storage/model_selection_storage.dart';

/// 图像生成服务
/// 支持 ModelScope 等兼容 OpenAI 格式的图像生成 API
class ImageGenService {
  /// 检查是否可用
  static bool get isAvailable => ApiSecrets.hasBuiltInImageApi;

  /// 生成图片
  /// 返回 base64 编码的图片数据，出错返回 null
  static Future<String?> generateImage({
    required String prompt,
    String? negativePrompt,
    int? width,
    int? height,
  }) async {
    if (!isAvailable) {
      debugPrint('Image generation API not available');
      return null;
    }

    try {
      final selectedModel = await ModelSelectionStorage.getImageModel();
      final model = selectedModel.id;
      
      final uri = Uri.parse('${ApiSecrets.imageBaseUrl}/images/generations');
      
      final body = jsonEncode({
        'model': model,
        'prompt': prompt,
        'n': 1,
        'size': '${width ?? 512}x${height ?? 512}',
        'response_format': 'b64_json',
      });

      debugPrint('Image generation request: $uri');
      debugPrint('Model: $model, Prompt: $prompt');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiSecrets.imageApiKey}',
        },
        body: body,
      ).timeout(
        const Duration(seconds: 120),
        onTimeout: () => throw Exception('图片生成超时'),
      );

      debugPrint('Image generation response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint('Image generation error: ${response.body}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      // 提取 base64 图片数据
      final dataList = data['data'] as List<dynamic>?;
      if (dataList != null && dataList.isNotEmpty) {
        final first = dataList[0] as Map<String, dynamic>;
        final b64Json = first['b64_json'] as String?;
        if (b64Json != null && b64Json.isNotEmpty) {
          return b64Json;
        }
        // 备用：尝试获取 URL
        final url = first['url'] as String?;
        if (url != null && url.isNotEmpty) {
          // 如果返回的是 URL，下载图片并转换为 base64
          return await _downloadAndConvertToBase64(url);
        }
      }

      debugPrint('No image data in response');
      return null;
    } catch (e) {
      debugPrint('Image generation error: $e');
      return null;
    }
  }

  /// 从 URL 下载图片并转换为 base64
  static Future<String?> _downloadAndConvertToBase64(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 60),
      );
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }
    } catch (e) {
      debugPrint('Failed to download image: $e');
    }
    return null;
  }
}
