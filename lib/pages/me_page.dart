import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zichat/pages/settings_page.dart';
import 'package:zichat/pages/services_page.dart';
import 'package:zichat/pages/my_qrcode_page.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEFF4), // HTML: background: #EFEFF4
      child: ListView(
        padding: const EdgeInsets.only(bottom: 12),
        children: [
          _buildProfileCard(context),
          const SizedBox(height: 12),
          _buildSection([
            _MeItem(
              icon: 'assets/icon/me/pay-success-outline.svg',
              label: '支付与服务',
              iconColor: const Color(0xFF07C160), // 绿色
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ServicesPage()),
                );
              },
            ),
          ]),
          const SizedBox(height: 12),
          _buildSection([
            _MeItem(
              icon: 'assets/icon/me/favorites.svg',
              label: '收藏',
              iconColor: const Color(0xFF5B8FD7), // 蓝色
            ),
            _MeItem(
              icon: 'assets/icon/me/album-outline.svg',
              label: '朋友圈',
              iconColor: const Color(0xFFEEAA4D), // 黄橙色
            ),
            _MeItem(
              icon: 'assets/icon/me/cards-offers.svg',
              label: '卡包',
              iconColor: const Color(0xFF07C160), // 绿色
            ),
            _MeItem(
              icon: 'assets/icon/keyboard-panel/emoji-icon.svg',
              label: '表情',
              iconColor: const Color(0xFFEEAA4D), // 黄橙色
            ),
          ]),
          const SizedBox(height: 12),
          _buildSection([
            _MeItem(
              icon: 'assets/icon/common/setting-outline.svg',
              label: '设置',
              iconColor: const Color(0xFF5B8FD7), // 蓝色
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 32, 16, 24), // HTML: padding: 32px 16px 24px 24px
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4), // HTML: border-radius: 4px
            child: Image.asset(
              'assets/me.png', // HTML: me.png
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 24), // HTML: margin-right: 24px
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bella',
                  style: TextStyle(
                    fontSize: 24, // HTML: font-size: 24px
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111), // HTML: color: #111
                    height: 1.1, // HTML: line-height: 1.1
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'ID：zion_guoguoguo', // HTML: 微信号
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8D8D8D), // HTML: color: #8d8d8d
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MyQrcodePage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icon/qr-code.svg',
                            width: 18, // HTML: width: 18px
                            height: 18,
                          ),
                          const SizedBox(width: 8), // HTML: gap: 8px
                          SvgPicture.asset(
                            'assets/icon/common/arrow-right.svg',
                            width: 10, // HTML: width: 10px
                            height: 16, // HTML: height: 16px
                            colorFilter: const ColorFilter.mode(
                              Color(0x73000000), // HTML: opacity: 0.45
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4), // HTML: gap: 6px 调整
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // HTML: padding: 4px 8px
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icon/common/plus.svg',
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF9B9B9B),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '状态',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9B9B9B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.fromLTRB(4, 2, 8, 2), // HTML: padding: 2px 8px 2px 4px
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _avatarStack(),
                          const SizedBox(width: 4),
                          const Text(
                            '还有 9 位朋友',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9B9B9B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 6, // HTML: width: 6px
                            height: 6, // HTML: height: 6px
                            decoration: BoxDecoration(
                              color: const Color(0xFFF54A45), // HTML: background: #f54a45
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarStack() {
    // HTML: margin-left: -4px 实现头像重叠效果
    return SizedBox(
      height: 16,
      width: 32, // 16 + 12 + 4 = 32
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          Positioned(
            left: 0,
            child: _MiniAvatar('assets/bella.jpeg'),
          ),
          Positioned(
            left: 12, // 16 - 4 = 12
            child: _MiniAvatar('assets/me.png'),
          ),
          Positioned(
            left: 24, // 16 + 16 - 4 - 4 = 24
            child: _MiniAvatar('assets/avatar.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(List<_MeItem> items) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            _MeListTile(
              item: items[i],
              isLast: i == items.length - 1,
            ),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar(this.asset);
  final String asset;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        asset,
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _MeItem {
  const _MeItem({
    required this.icon,
    required this.label,
    this.iconColor,
    this.onTap,
  });

  final String icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;
}

class _MeListTile extends StatelessWidget {
  const _MeListTile({
    required this.item,
    this.isLast = false,
  });

  final _MeItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        height: 54, // HTML: height: 54px
        padding: const EdgeInsets.only(left: 16, right: 12), // HTML: padding: 0 12px 0 16px
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFFEDEDED), // HTML: border-bottom: 0.5px solid #ededed
                    width: 0.5,
                  ),
                ), // HTML: .list-item:last-child { border-bottom: none; }
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              item.icon,
              width: 20, // HTML: width: 20px
              height: 20, // HTML: height: 20px
              colorFilter: item.iconColor != null
                  ? ColorFilter.mode(item.iconColor!, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(width: 14), // HTML: margin-right: 14px
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 16, // HTML: font-size: 16px
                  color: Color(0xFF111111), // HTML: color: #111
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/icon/common/arrow-right.svg',
              width: 8,
              height: 14,
              colorFilter: const ColorFilter.mode(
                Color(0x59000000), // HTML: opacity: 0.35
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
