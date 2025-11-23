import 'package:hive/hive.dart';

/// 全局 AI 配置（OpenAI / Gemini 等）
class AiGlobalConfig {
  AiGlobalConfig({
    required this.provider, // 'openai' 或 'gemini'
    required this.apiBaseUrl,
    required this.apiKey,
    required this.model,
    required this.persona,
  });

  final String provider;
  final String apiBaseUrl;
  final String apiKey;
  final String model;
  final String persona;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'provider': provider,
      'apiBaseUrl': apiBaseUrl,
      'apiKey': apiKey,
      'model': model,
      'persona': persona,
    };
  }

  static AiGlobalConfig? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return null;
    return AiGlobalConfig(
      provider: (map['provider'] ?? 'openai').toString(),
      apiBaseUrl: (map['apiBaseUrl'] ?? '').toString(),
      apiKey: (map['apiKey'] ?? '').toString(),
      model: (map['model'] ?? '').toString(),
      persona: (map['persona'] ?? '').toString(),
    );
  }
}

/// 负责存储 / 读取 AI 相关配置
class AiConfigStorage {
  static const String boxName = 'ai_config';
  static const String _globalKey = 'global';
  static const String _contactPrefix = 'contact:';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  /// 读取全局配置
  static Future<AiGlobalConfig?> loadGlobalConfig() async {
    final dynamic raw = _box.get(_globalKey);
    if (raw is Map) {
      return AiGlobalConfig.fromMap(raw);
    }
    return null;
  }

  /// 保存全局配置
  static Future<void> saveGlobalConfig(AiGlobalConfig config) async {
    await _box.put(_globalKey, config.toMap());
  }

  /// 读取单个会话的系统提示词
  static Future<String?> loadContactPrompt(String chatId) async {
    final dynamic raw = _box.get('$_contactPrefix$chatId');
    if (raw == null) return null;
    return raw.toString();
  }

  /// 保存单个会话的系统提示词
  static Future<void> saveContactPrompt(String chatId, String prompt) async {
    await _box.put('$_contactPrefix$chatId', prompt);
  }
}
