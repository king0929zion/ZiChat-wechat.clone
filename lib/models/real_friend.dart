import 'dart:io';

/// 真实好友数据模型
class RealFriend {
  final String id;
  final String name;
  final String avatar;
  final String wechatId;
  final String? signature;
  final FriendRequestStatus status;
  final DateTime? createdAt;
  final int unread;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  const RealFriend({
    required this.id,
    required this.name,
    required this.avatar,
    required this.wechatId,
    this.signature,
    this.status = FriendRequestStatus.approved,
    this.createdAt,
    this.unread = 0,
    this.lastMessage,
    this.lastMessageTime,
  });

  RealFriend copyWith({
    String? id,
    String? name,
    String? avatar,
    String? wechatId,
    String? signature,
    FriendRequestStatus? status,
    DateTime? createdAt,
    int? unread,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return RealFriend(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      wechatId: wechatId ?? this.wechatId,
      signature: signature ?? this.signature,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      unread: unread ?? this.unread,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'wechatId': wechatId,
      'signature': signature,
      'status': status.index,
      'createdAt': createdAt?.toIso8601String(),
      'unread': unread,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
    };
  }

  factory RealFriend.fromMap(Map<String, dynamic> map) {
    return RealFriend(
      id: map['id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      wechatId: map['wechatId'] as String,
      signature: map['signature'] as String?,
      status: FriendRequestStatus.values[map['status'] as int? ?? 0],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      unread: map['unread'] as int? ?? 0,
      lastMessage: map['lastMessage'] as String?,
      lastMessageTime: map['lastMessageTime'] != null ? DateTime.parse(map['lastMessageTime'] as String) : null,
    );
  }
}

/// 好友请求状态
enum FriendRequestStatus {
  pending,    // 待验证
  approved,   // 已通过
  rejected,   // 已拒绝
}
