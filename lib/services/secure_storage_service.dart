import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全加密存储服务
/// 使用 AES 加密保护敏感数据（如 API 密钥）
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _encryptionKeyPrefix = 'secure_';

  /// 生成加密密钥（从固定盐值派生）
  static String _deriveKey(String data) {
    final salt = utf8.encode('ZiChatSecureSalt2024');
    final key = utf8.encode(data);
    final hmac = Hmac(sha256, salt);
    final digest = hmac.convert(key);
    return digest.toString();
  }

  /// 加密数据（简单 XOR 加密，配合 secure storage 使用）
  static String _encrypt(String plainText, String key) {
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(plainText);
    final encrypted = <int>[];

    for (int i = 0; i < dataBytes.length; i++) {
      encrypted.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64Encode(encrypted);
  }

  /// 解密数据
  static String _decrypt(String cipherText, String key) {
    final keyBytes = utf8.encode(key);
    final dataBytes = base64Decode(cipherText);
    final decrypted = <int>[];

    for (int i = 0; i < dataBytes.length; i++) {
      decrypted.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return utf8.decode(decrypted);
  }

  /// 保存加密数据
  static Future<void> setSecureString(String key, String value) async {
    final derivedKey = _deriveKey(key);
    final encrypted = _encrypt(value, derivedKey);
    await _storage.write(key: '$_encryptionKeyPrefix$key', value: encrypted);
  }

  /// 读取加密数据
  static Future<String?> getSecureString(String key) async {
    final encrypted = await _storage.read(key: '$_encryptionKeyPrefix$key');
    if (encrypted == null) return null;

    try {
      final derivedKey = _deriveKey(key);
      return _decrypt(encrypted, derivedKey);
    } catch (_) {
      return null;
    }
  }

  /// 删除加密数据
  static Future<void> deleteSecureString(String key) async {
    await _storage.delete(key: '$_encryptionKeyPrefix$key');
  }

  /// 检查密钥是否存在
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: '$_encryptionKeyPrefix$key');
  }

  /// 清除所有加密数据
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
