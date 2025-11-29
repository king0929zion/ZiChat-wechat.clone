import 'package:flutter/material.dart';

/// 应用全局颜色常量
class AppColors {
  AppColors._();

  // 主题色
  static const Color primary = Color(0xFF07C160);
  static const Color primaryLight = Color(0xFF95EC69);
  static const Color primaryDark = Color(0xFF06AD56);

  // 背景色
  static const Color background = Color(0xFFF7F7F7);
  static const Color backgroundChat = Color(0xFFEDEDED);
  static const Color surface = Colors.white;

  // 文字颜色
  static const Color textPrimary = Color(0xFF1D2129);
  static const Color textSecondary = Color(0xFF86909C);
  static const Color textHint = Color(0xFFB2B2B2);
  static const Color textWhite = Colors.white;

  // 边框和分割线
  static const Color border = Color(0xFFE5E6EB);
  static const Color divider = Color(0xFFE5E6EB);

  // 消息气泡
  static const Color bubbleOutgoing = Color(0xFF95EC69);
  static const Color bubbleIncoming = Colors.white;

  // 转账相关
  static const Color transferPending = Color(0xFFFF9852);
  static const Color transferAccepted = Color(0xFFFFD8AD);

  // 红包相关
  static const Color redPacketStart = Color(0xFFFB4A3C);
  static const Color redPacketEnd = Color(0xFFEF3A2E);

  // 状态色
  static const Color online = Color(0xFF23C343);
  static const Color unreadBadge = Color(0xFFfb6e77);
  static const Color error = Color(0xFFFF4D4F);

  // 遮罩
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x26000000);

  // 阴影
  static const Color shadow = Color(0x1A000000);
}

