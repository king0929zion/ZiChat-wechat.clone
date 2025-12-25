import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zichat/storage/user_profile_storage.dart';
import 'package:zichat/storage/friend_storage.dart';
import 'package:zichat/models/friend.dart';

/// 通用头像组件
/// 
/// 支持显示用户头像和好友头像，自动处理本地文件和 Asset 图片
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.path,
    this.size = 40,
    this.radius = 4,
    this.fallbackAsset = 'assets/avatar-default.jpeg',
  });
  
  /// 头像路径（可以是 Asset 路径或本地文件路径）
  final String? path;
  
  /// 头像尺寸
  final double size;
  
  /// 圆角半径
  final double radius;
  
  /// 默认头像
  final String fallbackAsset;
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: _buildImage(),
    );
  }
  
  Widget _buildImage() {
    final avatarPath = path ?? fallbackAsset;
    
    // 判断是 Asset 还是本地文件
    if (avatarPath.startsWith('assets/')) {
      return Image.asset(
        avatarPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    } else {
      return Image.file(
        File(avatarPath),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }
  }
  
  Widget _buildFallback() {
    return Image.asset(
      fallbackAsset,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}

/// 用户头像组件 - 自动获取当前用户头像
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.size = 40,
    this.radius = 4,
  });
  
  final double size;
  final double radius;
  
  @override
  Widget build(BuildContext context) {
    final profile = UserProfileStorage.getProfile();
    return Avatar(
      path: profile.avatar,
      size: size,
      radius: radius,
      fallbackAsset: 'assets/me.png',
    );
  }
}

/// 好友头像组件 - 根据好友 ID 获取头像
class FriendAvatar extends StatelessWidget {
  const FriendAvatar({
    super.key,
    required this.friendId,
    this.size = 40,
    this.radius = 4,
    this.friend,
  });
  
  /// 好友 ID
  final String friendId;
  
  /// 头像尺寸
  final double size;
  
  /// 圆角半径
  final double radius;
  
  /// 可选：直接传入好友对象，避免重复查找
  final Friend? friend;
  
  @override
  Widget build(BuildContext context) {
    final f = friend ?? FriendStorage.getFriend(friendId);
    return Avatar(
      path: f?.avatar,
      size: size,
      radius: radius,
      fallbackAsset: 'assets/avatar-default.jpeg',
    );
  }
}
