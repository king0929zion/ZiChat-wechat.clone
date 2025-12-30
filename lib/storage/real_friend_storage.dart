import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zichat/models/real_friend.dart';

/// 真实好友数据存储
class RealFriendStorage {
  static const String _boxName = 'real_friends';
  static Box<String>? _box;

  static Future<void> initialize() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  static Box<String> get _safeBox {
    if (_box == null) {
      throw Exception('RealFriendStorage not initialized');
    }
    return _box!;
  }

  /// 获取所有已通过的好友
  static List<RealFriend> getApprovedFriends() {
    final friends = <RealFriend>[];
    for (final key in _safeBox.keys) {
      final json = _safeBox.get(key);
      if (json != null) {
        try {
          final friend = RealFriend.fromMap(jsonDecode(json));
          if (friend.status == FriendRequestStatus.approved) {
            friends.add(friend);
          }
        } catch (_) {}
      }
    }
    // 按添加时间排序（新的在前）
    friends.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return friends;
  }

  /// 获取所有待验证的好友请求
  static List<RealFriend> getPendingRequests() {
    final friends = <RealFriend>[];
    for (final key in _safeBox.keys) {
      final json = _safeBox.get(key);
      if (json != null) {
        try {
          final friend = RealFriend.fromMap(jsonDecode(json));
          if (friend.status == FriendRequestStatus.pending) {
            friends.add(friend);
          }
        } catch (_) {}
      }
    }
    return friends;
  }

  /// 获取所有好友（包括待验证）
  static List<RealFriend> getAllFriends() {
    final friends = <RealFriend>[];
    for (final key in _safeBox.keys) {
      final json = _safeBox.get(key);
      if (json != null) {
        try {
          friends.add(RealFriend.fromMap(jsonDecode(json)));
        } catch (_) {}
      }
    }
    return friends;
  }

  /// 获取单个好友
  static RealFriend? getFriend(String id) {
    final json = _safeBox.get(id);
    if (json == null) return null;
    try {
      return RealFriend.fromMap(jsonDecode(json));
    } catch (_) {
      return null;
    }
  }

  /// 保存好友或好友请求
  static Future<void> saveFriend(RealFriend friend) async {
    await _safeBox.put(friend.id, jsonEncode(friend.toMap()));
  }

  /// 删除好友
  static Future<void> deleteFriend(String id) async {
    await _safeBox.delete(id);
  }

  /// 通过好友请求
  static Future<void> approveRequest(String id) async {
    final friend = getFriend(id);
    if (friend != null) {
      await saveFriend(friend.copyWith(
        status: FriendRequestStatus.approved,
        createdAt: DateTime.now(),
      ));
    }
  }

  /// 拒绝好友请求
  static Future<void> rejectRequest(String id) async {
    final friend = getFriend(id);
    if (friend != null) {
      await saveFriend(friend.copyWith(status: FriendRequestStatus.rejected));
    }
  }

  /// 更新最后消息
  static Future<void> updateLastMessage(String id, String message) async {
    final friend = getFriend(id);
    if (friend != null) {
      await saveFriend(friend.copyWith(
        lastMessage: message,
        lastMessageTime: DateTime.now(),
      ));
    }
  }

  /// 增加未读数
  static Future<void> incrementUnread(String id) async {
    final friend = getFriend(id);
    if (friend != null) {
      await saveFriend(friend.copyWith(unread: friend.unread + 1));
    }
  }

  /// 清除未读数
  static Future<void> clearUnread(String id) async {
    final friend = getFriend(id);
    if (friend != null) {
      await saveFriend(friend.copyWith(unread: 0));
    }
  }

  /// 检查是否已经是好友
  static bool isFriend(String wechatId) {
    final friends = getApprovedFriends();
    return friends.any((f) => f.wechatId == wechatId);
  }

  /// 根据微信号查找好友
  static RealFriend? findByWechatId(String wechatId) {
    final friends = getApprovedFriends();
    try {
      return friends.firstWhere((f) => f.wechatId == wechatId);
    } catch (_) {
      return null;
    }
  }
}
