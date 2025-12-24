import 'package:flutter/material.dart';

/// 响应式断点定义
class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double widescreen = 1440;
}

/// 响应式布局类型
enum LayoutType {
  mobile,
  tablet,
  desktop,
}

/// 响应式布局信息
class ResponsiveInfo {
  final LayoutType layoutType;
  final double screenWidth;
  final double screenHeight;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final double maxContentWidth;
  final EdgeInsets contentPadding;

  const ResponsiveInfo({
    required this.layoutType,
    required this.screenWidth,
    required this.screenHeight,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.maxContentWidth,
    required this.contentPadding,
  });

  /// 根据上下文创建响应式信息
  factory ResponsiveInfo.of(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    
    LayoutType layoutType;
    bool isMobile = false;
    bool isTablet = false;
    bool isDesktop = false;
    double maxContentWidth;
    EdgeInsets contentPadding;

    if (width < Breakpoints.tablet) {
      layoutType = LayoutType.mobile;
      isMobile = true;
      maxContentWidth = 480;
      contentPadding = EdgeInsets.zero;
    } else if (width < Breakpoints.desktop) {
      layoutType = LayoutType.tablet;
      isTablet = true;
      maxContentWidth = 600;
      contentPadding = const EdgeInsets.symmetric(horizontal: 24);
    } else {
      layoutType = LayoutType.desktop;
      isDesktop = true;
      maxContentWidth = 800;
      contentPadding = const EdgeInsets.symmetric(horizontal: 48);
    }

    return ResponsiveInfo(
      layoutType: layoutType,
      screenWidth: width,
      screenHeight: size.height,
      isMobile: isMobile,
      isTablet: isTablet,
      isDesktop: isDesktop,
      maxContentWidth: maxContentWidth,
      contentPadding: contentPadding,
    );
  }
}

/// 响应式布局构建器
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveInfo.of(context));
  }
}

/// 响应式容器 - 自动居中并限制最大宽度
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.maxWidth,
  });

  final Widget child;
  final Color? backgroundColor;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final info = ResponsiveInfo.of(context);
    
    return Container(
      color: backgroundColor,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? info.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// 响应式值选择器
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T resolve(ResponsiveInfo info) {
    if (info.isDesktop && desktop != null) return desktop as T;
    if (info.isTablet && tablet != null) return tablet as T;
    return mobile;
  }

  static T of<T>(BuildContext context, ResponsiveValue<T> value) {
    return value.resolve(ResponsiveInfo.of(context));
  }
}

/// 响应式扩展方法
extension ResponsiveContext on BuildContext {
  ResponsiveInfo get responsive => ResponsiveInfo.of(this);
  
  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  
  double get screenWidth => responsive.screenWidth;
  double get screenHeight => responsive.screenHeight;
}
