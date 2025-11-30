import 'package:hive_flutter/hive_flutter.dart';

/// 聊天背景存储
class ChatBackgroundStorage {
  static const String _boxName = 'chat_backgrounds';
  static Box<String>? _box;

  static Future<void> initialize() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  static Box<String> get _safeBox {
    if (_box == null || !_box!.isOpen) {
      throw Exception('ChatBackgroundStorage not initialized');
    }
    return _box!;
  }

  /// 获取聊天背景
  static String? getBackground(String chatId) {
    try {
      return _safeBox.get(chatId);
    } catch (_) {
      return null;
    }
  }

  /// 设置聊天背景
  static Future<void> setBackground(String chatId, String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      await _safeBox.delete(chatId);
    } else {
      await _safeBox.put(chatId, imagePath);
    }
  }

  /// 获取全局默认背景
  static String? getDefaultBackground() {
    try {
      return _safeBox.get('_default_');
    } catch (_) {
      return null;
    }
  }

  /// 设置全局默认背景
  static Future<void> setDefaultBackground(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      await _safeBox.delete('_default_');
    } else {
      await _safeBox.put('_default_', imagePath);
    }
  }

  /// 清除聊天背景
  static Future<void> clearBackground(String chatId) async {
    await _safeBox.delete(chatId);
  }
}

