import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zichat/constants/app_assets.dart';

/// SVG 预加载服务
/// 在应用启动时预加载常用的 SVG 资源，提升后续渲染性能
class SvgPrecacheService {
  SvgPrecacheService._();

  static bool _initialized = false;
  static final Map<String, PictureInfo> _cache = {};

  /// 预加载所有 SVG 资源
  static Future<void> precacheAll(BuildContext context) async {
    if (_initialized) return;

    try {
      await Future.wait(
        AppAssets.preloadSvgAssets.map((asset) => _precacheSvg(asset)),
      );
      _initialized = true;
      debugPrint('SVG precache completed: ${_cache.length} assets loaded');
    } catch (e) {
      debugPrint('SVG precache error: $e');
    }
  }

  /// 预加载单个 SVG
  static Future<void> _precacheSvg(String assetPath) async {
    try {
      final loader = SvgAssetLoader(assetPath);
      final pictureInfo = await vg.loadPicture(loader, null);
      _cache[assetPath] = pictureInfo;
    } catch (e) {
      debugPrint('Failed to precache SVG: $assetPath - $e');
    }
  }

  /// 获取缓存的 SVG
  static PictureInfo? getCached(String assetPath) {
    return _cache[assetPath];
  }

  /// 清除缓存
  static void clearCache() {
    for (final info in _cache.values) {
      info.picture.dispose();
    }
    _cache.clear();
    _initialized = false;
  }
}

/// 优化的 SVG 图标组件，支持动画效果
class AnimatedSvgIcon extends StatefulWidget {
  const AnimatedSvgIcon({
    super.key,
    required this.asset,
    this.size = 24,
    this.color,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
    this.enablePressAnimation = true,
  });

  final String asset;
  final double size;
  final Color? color;
  final Duration duration;
  final VoidCallback? onTap;
  final bool enablePressAnimation;

  @override
  State<AnimatedSvgIcon> createState() => _AnimatedSvgIconState();
}

class _AnimatedSvgIconState extends State<AnimatedSvgIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = SvgPicture.asset(
      widget.asset,
      width: widget.size,
      height: widget.size,
      colorFilter: widget.color != null
          ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
          : null,
    );

    if (widget.onTap != null) {
      icon = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: icon,
        ),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: icon,
    );
  }
}

