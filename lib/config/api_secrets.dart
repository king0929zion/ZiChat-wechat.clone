/// API 密钥配置
class ApiSecrets {
  // 对话 API (MegaLLM OpenAI 兼容)
  static const String chatApiKey =
      'sk-mega-e49c9cc780022c8a8b0fb247e0aa2a2ee772c44df32219170d45429a0d08a3bc';
  static const String chatBaseUrl = 'https://ai.megallm.io/v1';
  
  // 图像生成 API (ModelScope)
  static const String imageApiKey = 'ms-a2995d2b-3843-456a-83fc-3c813e696b08';
  static const String imageBaseUrl = 'https://api-inference.modelscope.cn/v1';
  
  /// 检查是否配置了内置 API
  static bool get hasBuiltInChatApi => chatApiKey.isNotEmpty;
  static bool get hasBuiltInImageApi => imageApiKey.isNotEmpty;
}

