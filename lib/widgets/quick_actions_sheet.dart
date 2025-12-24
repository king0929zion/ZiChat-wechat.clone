import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zichat/constants/app_assets.dart';
import 'package:zichat/constants/app_colors.dart';
import 'package:zichat/constants/app_styles.dart';
import 'package:zichat/pages/code_scanner_page.dart';
import 'package:zichat/pages/money_qrcode_page.dart';

/// 显示快速操作弹窗
void showQuickActionsSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return QuickActionsSheet(parentContext: context);
    },
  );
}

/// 快速操作底部弹窗
class QuickActionsSheet extends StatefulWidget {
  const QuickActionsSheet({super.key, required this.parentContext});

  final BuildContext parentContext;

  @override
  State<QuickActionsSheet> createState() => _QuickActionsSheetState();
}

class _QuickActionsSheetState extends State<QuickActionsSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppStyles.animationNormal,
    );
    _slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildItem({
    required String label,
    required String icon,
    VoidCallback? onTap,
    int index = 0,
  }) {
    Widget leading;
    if (icon.endsWith('.svg')) {
      leading = SvgPicture.asset(icon, width: 22, height: 22);
    } else {
      leading = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(icon, width: 22, height: 22, fit: BoxFit.cover),
      );
    }

    return _QuickActionItem(
      label: label,
      leading: leading,
      onTap: () {
        Navigator.of(context).pop();
        if (onTap != null) {
          onTap();
        } else {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(
              content: Text('$label 功能暂未开放'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
          boxShadow: AppStyles.shadowMedium,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              _buildItem(
                index: 0,
                label: '发起群聊',
                icon: AppAssets.iconPlus,
              ),
              _buildItem(
                index: 1,
                label: '加入群聊',
                icon: AppAssets.iconPlus,
              ),
              _buildItem(
                index: 2,
                label: '扫一扫',
                icon: 'assets/icon/discover/scan-v2.jpeg',
                onTap: () {
                  Navigator.of(widget.parentContext).push(
                    MaterialPageRoute(builder: (_) => const CodeScannerPage()),
                  );
                },
              ),
              _buildItem(
                index: 3,
                label: '收付款',
                icon: 'assets/icon/discover/qrcode.svg',
                onTap: () {
                  Navigator.of(widget.parentContext).push(
                    MaterialPageRoute(builder: (_) => const MoneyQrcodePage()),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// 快速操作项组件
class _QuickActionItem extends StatefulWidget {
  const _QuickActionItem({
    required this.label,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final Widget leading;
  final VoidCallback onTap;

  @override
  State<_QuickActionItem> createState() => _QuickActionItemState();
}

class _QuickActionItemState extends State<_QuickActionItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: AppStyles.animationFast,
        color: _isPressed ? AppColors.background : AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              widget.leading,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: AppStyles.titleSmall,
                ),
              ),
              SvgPicture.asset(
                AppAssets.iconArrowRight,
                width: 12,
                height: 12,
                colorFilter: const ColorFilter.mode(
                  AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
