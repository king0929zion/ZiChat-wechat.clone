import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zichat/models/api_config.dart';
import 'package:zichat/services/secure_storage_service.dart';

/// API 配置存储服务（支持 API 密钥加密）
class ApiConfigStorage {
  static const String _boxName = 'api_configs';
  static const String _apiKeyPrefix = 'api_key_';
  static Box<String>? _box;

  /// 初始化
  static Future<void> initialize() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  static Box<String> get _safeBox {
    if (_box == null) {
      throw Exception('ApiConfigStorage not initialized');
    }
    return _box!;
  }

  /// 获取所有 API 配置
  static Future<List<ApiConfig>> getAllConfigs() async {
    final configs = <ApiConfig>[];
    for (final key in _safeBox.keys) {
      final json = _safeBox.get(key);
      if (json != null) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          final apiKey = await SecureStorageService.getSecureString('$_apiKeyPrefix$key');
          if (apiKey != null) {
            map['apiKey'] = apiKey;
            configs.add(ApiConfig.fromMap(map));
          }
        } catch (_) {}
      }
    }
    // 按创建时间排序
    configs.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.now();
      final bTime = b.createdAt ?? DateTime.now();
      return bTime.compareTo(aTime);
    });
    return configs;
  }

  /// 获取单个配置
  static Future<ApiConfig?> getConfig(String id) async {
    final json = _safeBox.get(id);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      final apiKey = await SecureStorageService.getSecureString('$_apiKeyPrefix$id');
      if (apiKey != null) {
        map['apiKey'] = apiKey;
        return ApiConfig.fromMap(map);
      }
    } catch (_) {}
    return null;
  }

  /// 保存配置
  static Future<void> saveConfig(ApiConfig config) async {
    // 加密存储 API 密钥
    await SecureStorageService.setSecureString('$_apiKeyPrefix${config.id}', config.apiKey);

    // 存储其他配置信息（不包含明文 API 密钥）
    final map = config.toMap();
    map.remove('apiKey');
    await _safeBox.put(config.id, jsonEncode(map));
  }

  /// 删除配置
  static Future<void> deleteConfig(String id) async {
    await _safeBox.delete(id);
    await SecureStorageService.deleteSecureString('$_apiKeyPrefix$id');
  }

  /// 设置活动配置
  static Future<void> setActiveConfig(String id) async {
    // 取消所有活动的配置
    final configs = await getAllConfigs();
    for (final config in configs) {
      if (config.isActive) {
        await saveConfig(config.copyWith(isActive: false));
      }
    }
    // 设置新的活动配置
    final target = await getConfig(id);
    if (target != null) {
      await saveConfig(target.copyWith(isActive: true));
    }
  }

  /// 获取当前活动的配置
  static Future<ApiConfig?> getActiveConfig() async {
    final configs = await getAllConfigs();
    try {
      return configs.firstWhere((c) => c.isActive);
    } catch (_) {
      return null;
    }
  }

  /// 检查是否已配置 API
  static Future<bool> hasConfig() async {
    return await getActiveConfig() != null;
  }
}
