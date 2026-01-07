/// 应用常量定义
/// 集中管理所有魔法数字和配置常量
class AppConstants {
  // ==================== 聊天相关常量 ====================

  /// 最大聊天历史条数
  static const int maxChatHistoryItems = 20;

  /// 最大上下文 Token 数量（用于控制上下文长度）
  static const int maxContextTokens = 3000;

  /// 消息默认超时时间（秒）
  static const int defaultMessageTimeout = 120;

  /// 图片生成超时时间（秒）
  static const int imageGenerationTimeout = 120;

  /// 图片下载超时时间（秒）
  static const int imageDownloadTimeout = 60;

  /// 消息分页大小
  static const int messagePageSize = 50;

  /// 最大消息搜索结果数
  static const int maxMessageSearchResults = 100;

  // ==================== AI 相关常量 ====================

  /// AI 默认温度参数
  static const double defaultAiTemperature = 0.7;

  /// AI 默认 top_p 参数
  static const double defaultAiTopP = 0.9;

  /// AI 默认最大 token 数
  static const int defaultAiMaxTokens = 4096;

  /// 模拟真人回复延迟最小值（毫秒）
  static const int minHumanLikeDelay = 800;

  /// 模拟真人回复延迟最大值（毫秒）
  static const int maxHumanLikeDelay = 2000;

  // ==================== 图片相关常量 ====================

  /// 缩略图最大宽度
  static const int maxThumbnailWidth = 200;

  /// 缩略图最大高度
  static const int maxThumbnailHeight = 200;

  /// 消息图片最大宽度
  static const int maxMessageImageWidth = 800;

  /// 消息图片最大高度
  static const int maxMessageImageHeight = 800;

  /// 缩略图质量 (0-100)
  static const int thumbnailQuality = 85;

  /// 消息图片质量 (0-100)
  static const int messageImageQuality = 90;

  // ==================== UI 相关常量 ====================

  /// 默认动画持续时间（毫秒）
  static const int defaultAnimationDuration = 300;

  /// 快速动画持续时间（毫秒）
  static const int fastAnimationDuration = 150;

  /// 慢速动画持续时间（毫秒）
  static const int slowAnimationDuration = 500;

  /// 列表项高度（像素）
  static const double listItemHeight = 56.0;

  /// 最大内容宽度（像素）
  static const double maxContentWidth = 480.0;

  /// 默认边距（像素）
  static const double defaultMargin = 16.0;

  /// 小边距（像素）
  static const double smallMargin = 8.0;

  /// 大边距（像素）
  static const double largeMargin = 24.0;

  // ==================== 存储相关常量 ====================

  /// API 密钥存储前缀
  static const String apiKeyStoragePrefix = 'api_key_';

  /// 聊天历史存储键前缀
  static const String chatHistoryPrefix = 'chat_history_';

  /// 用户设置存储键
  static const String userSettingsKey = 'user_settings';

  // ==================== 网络相关常量 ====================

  /// 网络请求重试次数
  static const int maxRequestRetries = 3;

  /// 网络请求重试延迟（毫秒）
  static const int requestRetryDelay = 1000;

  /// 连接超时时间（秒）
  static const int connectionTimeout = 30;

  // ==================== 性能相关常量 ====================

  /// 缓存过期时间（秒）
  static const int cacheExpirationTime = 3600;

  /// 最大缓存条目数
  static const int maxCacheEntries = 100;

  /// 列表虚拟化缓冲区大小
  static const int listBufferItemCount = 5;

  // ==================== 通知相关常量 ====================

  /// 主动消息检查间隔（分钟）
  static const int proactiveMessageCheckInterval = 30;

  /// 主动消息最小间隔（小时）
  static const int proactiveMessageMinInterval = 2;

  /// 主动消息触发概率 (0.0 - 1.0)
  static const double proactiveMessageTriggerProbability = 0.1;

  // ==================== 字符串处理常量 ====================

  /// 消息分隔符
  static const String messageSeparator = '||';

  /// 默认空字符串
  static const String emptyString = '';

  /// 最大字符串长度（用于文本截断）
  static const int maxStringLength = 1000;

  // ==================== 时间相关常量 ====================

  /// 一天的毫秒数
  static const int millisecondsPerDay = 86400000;

  /// 一小时的毫秒数
  static const int millisecondsPerHour = 3600000;

  /// 一分钟的毫秒数
  static const int millisecondsPerMinute = 60000;

  // 私有构造函数，防止实例化
  AppConstants._();
}
