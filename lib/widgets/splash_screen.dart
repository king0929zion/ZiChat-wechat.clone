import 'package:flutter/material.dart';
import 'package:zichat/constants/app_colors.dart';

/// 启动画面 - 预加载资源
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _loadResources();
  }

  Future<void> _loadResources() async {
    // 模拟最小加载时间
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() => _isLoading = false);
      // 等待动画完成后回调
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        widget.onComplete();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/app_icon/xehelper.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'ZiChat',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: const Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
