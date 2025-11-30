import 'package:hive/hive.dart';

class ChatStorage {
  static const String boxName = 'chat_messages';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  static Future<List<Map<String, dynamic>>> loadMessages(String chatId) async {
    final dynamic raw = _box.get(chatId);
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => e.map((key, value) => MapEntry(key.toString(), value)))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  /// 分页加载消息
  static Future<List<Map<String, dynamic>>> loadMessagesPaged(
    String chatId, {
    int offset = 0,
    int limit = 30,
  }) async {
    final allMessages = await loadMessages(chatId);
    if (allMessages.isEmpty) return [];
    
    // 从最新消息开始倒序取
    final startIndex = allMessages.length - offset - limit;
    final endIndex = allMessages.length - offset;
    
    if (startIndex < 0) {
      return allMessages.sublist(0, endIndex.clamp(0, allMessages.length));
    }
    return allMessages.sublist(startIndex.clamp(0, allMessages.length), endIndex.clamp(0, allMessages.length));
  }

  /// 获取消息总数
  static Future<int> getMessageCount(String chatId) async {
    final allMessages = await loadMessages(chatId);
    return allMessages.length;
  }

  static bool hasMessages(String chatId) {
    return _box.containsKey(chatId);
  }

  static Future<void> saveMessages(
    String chatId,
    List<Map<String, dynamic>> messages,
  ) async {
    await _box.put(chatId, messages);
  }

  /// 搜索消息
  static Future<List<SearchResult>> searchMessages(
    String chatId,
    String keyword,
  ) async {
    if (keyword.trim().isEmpty) return [];
    
    final allMessages = await loadMessages(chatId);
    final results = <SearchResult>[];
    final lowerKeyword = keyword.toLowerCase();
    
    for (int i = 0; i < allMessages.length; i++) {
      final msg = allMessages[i];
      final text = (msg['text'] as String?)?.toLowerCase() ?? '';
      if (text.contains(lowerKeyword)) {
        results.add(SearchResult(
          messageIndex: i,
          messageId: msg['id'] as String? ?? '',
          text: msg['text'] as String? ?? '',
          timestamp: msg['timestamp'] != null
              ? DateTime.fromMillisecondsSinceEpoch(msg['timestamp'] as int)
              : null,
          isOutgoing: msg['direction'] == 'out',
        ));
      }
    }
    
    return results.reversed.toList(); // 最新的在前
  }

  /// 全局搜索所有聊天
  static Future<Map<String, List<SearchResult>>> searchAllChats(
    String keyword,
  ) async {
    if (keyword.trim().isEmpty) return {};
    
    final results = <String, List<SearchResult>>{};
    
    for (final key in _box.keys) {
      final chatId = key.toString();
      final chatResults = await searchMessages(chatId, keyword);
      if (chatResults.isNotEmpty) {
        results[chatId] = chatResults;
      }
    }
    
    return results;
  }

  /// 清除聊天记录
  static Future<void> clearMessages(String chatId) async {
    await _box.delete(chatId);
  }
}

/// 搜索结果
class SearchResult {
  final int messageIndex;
  final String messageId;
  final String text;
  final DateTime? timestamp;
  final bool isOutgoing;

  SearchResult({
    required this.messageIndex,
    required this.messageId,
    required this.text,
    this.timestamp,
    required this.isOutgoing,
  });
}
