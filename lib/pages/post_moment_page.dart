import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostMomentPage extends StatefulWidget {
  const PostMomentPage({super.key});

  @override
  State<PostMomentPage> createState() => _PostMomentPageState();
}

class _PostMomentPageState extends State<PostMomentPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            color: Colors.white,
            child: Column(
              children: [
                // Header
                Container(
                  height: 44, // HTML: height: 44px
                  padding: const EdgeInsets.symmetric(horizontal: 10), // HTML: padding: 0 10px
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFF0F0F0), // HTML: border-bottom: 0.5px solid #f0f0f0
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(6), // HTML: padding: 6px
                        onPressed: () => Navigator.of(context).pop(),
                        icon: SvgPicture.asset(
                          'assets/icon/common/go-back.svg',
                          width: 12,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF1D2129),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                            _textController.text.trim(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF07C160), // HTML: background: #07C160
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14, // HTML: padding: 6px 14px
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6), // HTML: border-radius: 6px
                          ),
                        ),
                        child: const Text(
                          '发表',
                          style: TextStyle(
                            fontSize: 15, // HTML: font-size: 15px
                            fontWeight: FontWeight.w500, // HTML: font-weight: 500
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      14,
                      12,
                      14,
                      24,
                    ), // HTML: padding: 12px 14px 24px
                    children: [
                      // 文本输入框
                      TextField(
                        controller: _textController,
                        minLines: 3,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: '这一刻的想法...', // HTML: placeholder
                          hintStyle: TextStyle(
                            fontSize: 16, // HTML: font-size: 16px
                            color: Color(0xFFBBBBBB),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 12), // HTML: gap: 12px
                      // 图片网格
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 8, // HTML: gap: 8px
                        mainAxisSpacing: 8,
                        children: const [
                          _MediaItem(
                            image: 'assets/icon/discover/top-stories.jpeg',
                          ),
                          _MediaItem(image: 'assets/avatar-default.jpeg'),
                          _MediaItem(image: 'assets/bella.jpeg'),
                          _MediaItem(image: 'assets/icon/discover/games.jpeg'),
                          _AddMediaButton(),
                        ],
                      ),
                      const SizedBox(height: 26), // HTML: margin-top: 26px
                      // 选项列表
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFF0F0F0), // HTML: border-top: 0.5px solid #f0f0f0
                              width: 0.5,
                            ),
                            bottom: BorderSide(
                              color:
                                  Color(0xFFF0F0F0), // HTML: border-bottom: 0.5px solid #f0f0f0
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          children: const [
                            _OptionRow(
                              icon: 'assets/icon/discover/location.svg',
                              label: '所在位置',
                            ),
                            _OptionRow(
                              icon: 'assets/icon/discover/at.svg',
                              label: '提醒谁看',
                            ),
                            _OptionRow(
                              icon:
                                  'assets/icon/discover/location.svg', // 项目中没有 visible.svg
                              label: '谁可以看',
                              value: '公开',
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaItem extends StatelessWidget {
  const _MediaItem({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2), // HTML: border-radius: 2px
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _AddMediaButton extends StatelessWidget {
  const _AddMediaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showSimpleSnackBar(context, '图片选择功能暂未开放');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7), // HTML: background: #f7f7f7
          border: Border.all(
            color: const Color(0xFFDCDCDC), // HTML: border: 1px dashed #dcdcdc
            style: BorderStyle.solid, // Flutter 不支持虚线，用实线代替
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 28, // HTML: font-size: 28px
              color: Color(0xFF8A8F99), // HTML: color: #8a8f99
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.label,
    this.value,
    this.isLast = false,
  });

  final String icon;
  final String label;
  final String? value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showSimpleSnackBar(context, '功能暂未开放');
      },
      child: Container(
        height: 48, // HTML: height: 48px
        padding: const EdgeInsets.symmetric(horizontal: 14), // HTML: padding: 0 14px
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFFF0F0F0), // HTML: border-bottom: 0.5px solid #f0f0f0
                    width: 0.5,
                  ),
                ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 18, // HTML: width: 18px
              height: 18, // HTML: height: 18px
            ),
            const SizedBox(width: 10), // HTML: gap: 10px
            Text(
              label,
              style: const TextStyle(
                fontSize: 15, // HTML: font-size: 15px
                color: Color(0xFF222222), // HTML: color: #222
              ),
            ),
            const Spacer(),
            if (value != null) ...[
              Text(
                value!,
                style: const TextStyle(
                  fontSize: 14, // HTML: font-size: 14px
                  color: Color(0xFF8A8A8A), // HTML: color: #8a8a8a
                ),
              ),
              const SizedBox(width: 8), // HTML: margin-right: 8px
            ],
            SvgPicture.asset(
              'assets/icon/common/arrow-right.svg',
              width: 8,
              height: 14,
              colorFilter: const ColorFilter.mode(
                Color(0x66000000), // HTML: opacity: 0.4
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showSimpleSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
}
