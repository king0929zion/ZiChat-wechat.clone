import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// 头像工具类
class AvatarUtils {
  /// 默认用户头像
  static const String defaultUserAvatar = 'assets/me.png';

  /// 默认好友头像
  static const String defaultFriendAvatar = 'assets/avatar-default.jpeg';

  /// 判断是否为资源图片
  static bool isAssetImage(String path) => path.startsWith('assets/');

  /// 构建图片提供者
  static ImageProvider buildImageProvider(String path) {
    if (isAssetImage(path)) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  /// 获取头像 Widget
  static Widget buildAvatarWidget(
    String path, {
    double size = 48,
    double borderRadius = 8,
    BoxFit fit = BoxFit.cover,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image(
        image: buildImageProvider(path),
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildErrorPlaceholder(size),
      ),
    );
  }

  /// 获取圆形头像 Widget
  static Widget buildCircleAvatarWidget(
    String path, {
    double size = 40,
  }) {
    return ClipOval(
      child: Image(
        image: buildImageProvider(path),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildErrorPlaceholder(size, isCircle: true),
      ),
    );
  }

  /// 构建错误占位符
  static Widget _buildErrorPlaceholder(double size, {bool isCircle = false}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Colors.grey[400],
      ),
    );
  }

  /// 保存图片到应用目录
  static Future<String> saveImageToAppDir(File imageFile, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final savedFile = await imageFile.copy(filePath);
    return savedFile.path;
  }

  /// 生成头像文件名
  static String generateAvatarFileName({String? userId}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final id = userId ?? 'user';
    return 'avatar_${id}_$timestamp.jpg';
  }
}
