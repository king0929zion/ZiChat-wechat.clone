import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDED),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icon/common/go-back.svg',
            width: 12, // HTML: width: 12px
            height: 20, // HTML: height: 20px
            colorFilter: const ColorFilter.mode(
              Color(0xFF1D2129),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '服务',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D2129),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icon/three-dot.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF1D2129),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 钱包卡片
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.fromLTRB(40, 24, 40, 40), // HTML: padding: 24px 40px 40px
            decoration: BoxDecoration(
              color: const Color(0xFF07C160), // HTML: background-color: #07C160
              borderRadius: BorderRadius.circular(4), // HTML: border-radius: 4px
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WalletItem(
                  icon: 'assets/icon/chats/money-outline.svg',
                  label: '零钱',
                ),
                _WalletItem(
                  icon: 'assets/icon/chats/wallet-outline.svg',
                  label: '钱包',
                  showBalance: true,
                ),
              ],
            ),
          ),
          // 服务内容图片
          Image.asset(
            'assets/cn-service-up.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/cn-service-down.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class _WalletItem extends StatelessWidget {
  const _WalletItem({
    required this.icon,
    required this.label,
    this.showBalance = false,
  });

  final String icon;
  final String label;
  final bool showBalance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100, // HTML: min-width: 100px
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 38, // HTML: width: 38px
            height: 38, // HTML: height: 38px
            colorFilter: const ColorFilter.mode(
              Colors.white, // HTML: filter: brightness(0) invert(1)
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4), // HTML: margin-bottom: 4px
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showBalance) ...[
            const SizedBox(height: 8), // HTML: margin-bottom: 8px
            const SizedBox(
              width: 100, // HTML: width: 100px
              child: Center(
                child: SizedBox(
                  width: 16, // HTML: width: 16px
                  height: 16, // HTML: height: 16px
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
