/// API 密钥配置
/// 
/// 这些值在编译时通过 --dart-define 注入
/// 本地开发时可以创建 .env 文件或直接修改这里的默认值
/// 
/// GitHub Actions 会自动从 Secrets 中读取并注入
class ApiSecrets {
  // 对话 API (iflow)
  static const String chatApiKey = String.fromEnvironment(
    'CHAT_API_KEY',
    defaultValue: '',
  );
  
  static const String chatBaseUrl = String.fromEnvironment(
    'CHAT_BASE_URL',
    defaultValue: 'https://apis.iflow.cn/v1/',
  );
  
  // 图像生成 API (ModelScope)
  static const String imageApiKey = String.fromEnvironment(
    'IMAGE_API_KEY',
    defaultValue: '',
  );
  
  static const String imageBaseUrl = String.fromEnvironment(
    'IMAGE_BASE_URL',
    defaultValue: 'https://api-inference.modelscope.cn/',
  );
  
  /// 检查是否配置了内置 API
  static bool get hasBuiltInChatApi => chatApiKey.isNotEmpty;
  static bool get hasBuiltInImageApi => imageApiKey.isNotEmpty;
}

