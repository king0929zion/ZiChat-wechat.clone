import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zichat/constants/app_colors.dart';
import 'package:zichat/constants/app_styles.dart';
import 'package:zichat/models/chat_message.dart';
import 'base_bubble.dart';

/// 图片消息气泡
class ImageBubble extends StatefulWidget {
  const ImageBubble({
    super.key,
    required this.message,
    this.onTap,
  });

  final ChatMessage message;
  final VoidCallback? onTap;

  @override
  State<ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppStyles.animationNormal,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onImageLoaded() {
    if (!_isLoaded) {
      _isLoaded = true;
      _controller.forward();
    }
  }

  void _showFullImage(BuildContext context) {
    HapticFeedback.lightImpact();
    
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _FullScreenImage(
            imagePath: widget.message.image ?? '',
            animation: animation,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageAsset = widget.message.image ?? '';

    Widget imageWidget;
    if (imageAsset.startsWith('assets/')) {
      imageWidget = Image.asset(
        imageAsset,
        width: 180,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            _onImageLoaded();
            return child;
          }
          return _buildPlaceholder();
        },
      );
    } else {
      imageWidget = Image.file(
        File(imageAsset),
        width: 180,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            _onImageLoaded();
            return child;
          }
          return _buildPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }

    return TappableBubble(
      onTap: () => _showFullImage(context),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Hero(
          tag: 'image_${widget.message.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
            child: imageWidget,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 180,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: 180,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
      ),
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 32,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// 全屏图片查看
class _FullScreenImage extends StatelessWidget {
  const _FullScreenImage({
    required this.imagePath,
    required this.animation,
  });

  final String imagePath;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (imagePath.startsWith('assets/')) {
      image = Image.asset(imagePath, fit: BoxFit.contain);
    } else {
      image = Image.file(File(imagePath), fit: BoxFit.contain);
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null &&
            details.primaryVelocity!.abs() > 300) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: image,
          ),
        ),
      ),
    );
  }
}

