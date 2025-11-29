/// 聊天消息数据模型
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.type,
    this.direction,
    this.name,
    this.text,
    this.avatar,
    this.image,
    this.duration,
    this.amount,
    this.status,
    this.note,
    this.sendStatus,
    this.timestamp,
  });

  final String id;
  /// 消息类型: text, image, voice, red-packet, transfer, timestamp, system, recall
  final String type;
  /// 消息方向: in（收到）, out（发出）
  final String? direction;
  final String? name;
  final String? text;
  final String? avatar;
  final String? image;
  final String? duration;
  final String? amount;
  final String? status;
  final String? note;
  /// 发送状态: sending, sent, failed
  final String? sendStatus;
  final DateTime? timestamp;

  /// 是否为外发消息
  bool get isOutgoing => direction == 'out';

  /// 是否为系统类消息（时间戳、系统提示、撤回等）
  bool get isSystemMessage =>
      type == 'timestamp' || type == 'system' || type == 'recall';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'direction': direction,
      'name': name,
      'text': text,
      'avatar': avatar,
      'image': image,
      'duration': duration,
      'amount': amount,
      'status': status,
      'note': note,
      'sendStatus': sendStatus,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      type: map['type'] as String,
      direction: map['direction'] as String?,
      name: map['name'] as String?,
      text: map['text'] as String?,
      avatar: map['avatar'] as String?,
      image: map['image'] as String?,
      duration: map['duration'] as String?,
      amount: map['amount'] as String?,
      status: map['status'] as String?,
      note: map['note'] as String?,
      sendStatus: map['sendStatus'] as String?,
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : null,
    );
  }

  /// 创建一个副本，可选择性地覆盖某些字段
  ChatMessage copyWith({
    String? id,
    String? type,
    String? direction,
    String? name,
    String? text,
    String? avatar,
    String? image,
    String? duration,
    String? amount,
    String? status,
    String? note,
    String? sendStatus,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      direction: direction ?? this.direction,
      name: name ?? this.name,
      text: text ?? this.text,
      avatar: avatar ?? this.avatar,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      note: note ?? this.note,
      sendStatus: sendStatus ?? this.sendStatus,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// 快速创建文本消息
  factory ChatMessage.text({
    required String id,
    required String text,
    required bool isOutgoing,
    String? avatar,
  }) {
    return ChatMessage(
      id: id,
      type: 'text',
      direction: isOutgoing ? 'out' : 'in',
      text: text,
      avatar: avatar ?? (isOutgoing ? 'assets/avatar.png' : 'assets/me.png'),
      timestamp: DateTime.now(),
      sendStatus: 'sending',
    );
  }

  /// 快速创建图片消息
  factory ChatMessage.image({
    required String id,
    required String imagePath,
    required bool isOutgoing,
    String? avatar,
  }) {
    return ChatMessage(
      id: id,
      type: 'image',
      direction: isOutgoing ? 'out' : 'in',
      image: imagePath,
      avatar: avatar ?? (isOutgoing ? 'assets/avatar.png' : 'assets/me.png'),
      timestamp: DateTime.now(),
      sendStatus: 'sending',
    );
  }

  /// 快速创建转账消息
  factory ChatMessage.transfer({
    required String id,
    required String amount,
    required bool isOutgoing,
    String? note,
    String? status,
    String? avatar,
  }) {
    return ChatMessage(
      id: id,
      type: 'transfer',
      direction: isOutgoing ? 'out' : 'in',
      amount: amount,
      note: note ?? '转账',
      status: status ?? (isOutgoing ? '待对方确认' : '待收款'),
      avatar: avatar ?? (isOutgoing ? 'assets/avatar.png' : 'assets/me.png'),
      timestamp: DateTime.now(),
    );
  }

  /// 快速创建系统消息
  factory ChatMessage.system({
    required String id,
    required String text,
  }) {
    return ChatMessage(
      id: id,
      type: 'system',
      text: text,
      timestamp: DateTime.now(),
    );
  }
}

/// 消息发送状态枚举
enum MessageSendStatus {
  sending,
  sent,
  failed,
}

