import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zichat/services/proactive_message_service.dart';

/// 聊天事件管理器
/// 
/// 负责管理主动消息、未读消息等事件，通知 UI 更新
class ChatEventManager extends ChangeNotifier {
  static final ChatEventManager _instance = ChatEventManager._internal();
  static ChatEventManager get instance => _instance;
  
  ChatEventManager._internal();
  
  Box<dynamic>? _eventBox;
  bool _initialized = false;
  
  // 待发送的主动消息 {chatId: message}
  final Map<String, String> _pendingProactiveMessages = {};
  
  // 各聊天的未读数 {chatId: count}
  final Map<String, int> _unreadCounts = {};
  
  /// 初始化
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      _eventBox = await Hive.openBox<dynamic>('chat_events');
      _loadUnreadCounts();
      
      // 监听主动消息服务
      ProactiveMessageService.instance.onProactiveMessage = _onProactiveMessage;
      
      _initialized = true;
    } catch (e) {
      debugPrint('ChatEventManager init error: $e');
    }
  }
  
  void _loadUnreadCounts() {
    final data = _eventBox?.get('unread_counts');
    if (data is Map) {
      for (final entry in data.entries) {
        _unreadCounts[entry.key.toString()] = entry.value as int? ?? 0;
      }
    }
  }
  
  Future<void> _saveUnreadCounts() async {
    await _eventBox?.put('unread_counts', _unreadCounts);
  }
  
  /// 收到主动消息
  void _onProactiveMessage(String chatId, String message) {
    _pendingProactiveMessages[chatId] = message;
    incrementUnread(chatId);
    notifyListeners();
  }
  
  /// 获取待发送的主动消息
  String? getPendingMessage(String chatId) {
    return _pendingProactiveMessages.remove(chatId);
  }
  
  /// 是否有待处理的主动消息
  bool hasPendingMessage(String chatId) {
    return _pendingProactiveMessages.containsKey(chatId);
  }
  
  /// 获取未读数
  int getUnreadCount(String chatId) {
    return _unreadCounts[chatId] ?? 0;
  }
  
  /// 增加未读数
  void incrementUnread(String chatId, [int count = 1]) {
    _unreadCounts[chatId] = (_unreadCounts[chatId] ?? 0) + count;
    _saveUnreadCounts();
    notifyListeners();
  }
  
  /// 清除未读数
  void clearUnread(String chatId) {
    if (_unreadCounts.containsKey(chatId)) {
      _unreadCounts[chatId] = 0;
      _saveUnreadCounts();
      notifyListeners();
    }
  }
  
  /// 获取总未读数
  int get totalUnread {
    return _unreadCounts.values.fold(0, (sum, count) => sum + count);
  }
  
  /// 添加一条新消息（AI回复后调用）
  void onNewMessage(String chatId, {bool fromAi = false}) {
    if (fromAi) {
      // AI 消息不增加未读（因为用户正在看）
    }
    notifyListeners();
  }
}

