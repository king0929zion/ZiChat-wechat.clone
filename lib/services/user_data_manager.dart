import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zichat/storage/user_profile_storage.dart';

/// 用户数据管理器 - 提供头像和昵称的实时更新能力
/// 使用 ChangeNotifier 实现观察者模式，支持 UI 实时刷新
class UserDataManager extends ChangeNotifier {
  static final UserDataManager instance = UserDataManager._();
  UserDataManager._();

  // 当前用户资料
  UserProfile _profile = const UserProfile();
  UserProfile get profile => _profile;

  // 头像图片提供者（用于 Image widget 自动刷新）
  ImageProvider? _avatarImageProvider;
  ImageProvider? get avatarImageProvider => _avatarImageProvider;

  // 监听器订阅
  StreamSubscription? _prefsSubscription;

  /// 初始化用户数据管理器
  Future<void> initialize() async {
    await UserProfileStorage.initialize();
    _loadProfile();
  }

  /// 加载用户资料
  void _loadProfile() {
    _profile = UserProfileStorage.getProfile();
    _avatarImageProvider = _buildAvatarProvider(_profile.avatar);
    notifyListeners();
  }

  /// 构建头像图片提供者
  ImageProvider _buildAvatarProvider(String avatarPath) {
    if (avatarPath.startsWith('assets/')) {
      return AssetImage(avatarPath);
    } else {
      return FileImage(File(avatarPath));
    }
  }

  /// 更新头像
  Future<bool> updateAvatar(String newAvatarPath) async {
    try {
      await UserProfileStorage.updateAvatar(newAvatarPath);
      _avatarImageProvider = _buildAvatarProvider(newAvatarPath);
      _profile = _profile.copyWith(avatar: newAvatarPath);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('更新头像失败: $e');
      return false;
    }
  }

  /// 从相册选择并更新头像
  Future<bool> pickAndUpdateAvatar(ImageSource source) async {
    // 这里由调用方传入 ImagePicker
    return true;
  }

  /// 更新昵称
  Future<bool> updateName(String newName) async {
    if (newName.isEmpty || newName.length > 20) return false;
    try {
      await UserProfileStorage.updateName(newName);
      _profile = _profile.copyWith(name: newName);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('更新昵称失败: $e');
      return false;
    }
  }

  /// 更新性别
  Future<bool> updateGender(String gender) async {
    try {
      await UserProfileStorage.updateGender(gender);
      _profile = _profile.copyWith(gender: gender);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('更新性别失败: $e');
      return false;
    }
  }

  /// 更新个性签名
  Future<bool> updateSignature(String signature) async {
    try {
      await UserProfileStorage.updateSignature(signature);
      _profile = _profile.copyWith(signature: signature);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('更新签名失败: $e');
      return false;
    }
  }

  /// 获取用户头像路径（兼容旧接口）
  String getAvatarPath() => _profile.avatar;

  /// 获取用户昵称（兼容旧接口）
  String getUserName() => _profile.name;

  /// 获取用户微信号
  String getWechatId() => _profile.wechatId;

  /// 获取用户性别
  String getGender() => _profile.gender;

  /// 获取个性签名
  String getSignature() => _profile.signature;

  /// 刷新用户数据（从存储重新加载）
  void refresh() {
    _loadProfile();
  }

  /// 复制并保存用户资料
  Future<void> saveFullProfile(UserProfile newProfile) async {
    await UserProfileStorage.saveProfile(newProfile);
    _profile = newProfile;
    _avatarImageProvider = _buildAvatarProvider(newProfile.avatar);
    notifyListeners();
  }
}
