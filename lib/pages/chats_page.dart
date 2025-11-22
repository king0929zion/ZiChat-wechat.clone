import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zichat/pages/chat_detail_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE5E6EB);
    const nameStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1D2129),
    );
    const messageStyle = TextStyle(
      fontSize: 14,
      color: Color(0xFF86909C),
    );
    const timeStyle = TextStyle(
      fontSize: 12,
      color: Color(0xFF86909C),
    );

    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _mockChats.length,
        itemBuilder: (context, index) {
          final chat = _mockChats[index];
          final bool isLast = index == _mockChats.length - 1;

          return Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const ChatDetailPage(),
                  ),
                );
              },
              child: SizedBox(
                height: 72,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                chat.avatar,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (chat.unread > 0)
                              Positioned(
                                top: -6,
                                right: -6,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFfb6e77),
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${chat.unread}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            if (chat.online)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF23C343),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          border: isLast
                              ? null
                              : const Border(
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: 0.5,
                                  ),
                                ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    chat.title,
                                    style: nameStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  chat.latestTime,
                                  style: timeStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    chat.latestMessage,
                                    style: messageStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (chat.muted)
                                  SvgPicture.asset(
                                    'assets/icon/mute-ring.svg',
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF86909C),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChatItem {
  const _ChatItem({
    required this.id,
    required this.title,
    required this.avatar,
    required this.latestMessage,
    required this.latestTime,
    required this.unread,
    required this.muted,
    required this.online,
  });

  final String id;
  final String title;
  final String avatar;
  final String latestMessage;
  final String latestTime;
  final int unread;
  final bool muted;
  final bool online;
}

const List<_ChatItem> _mockChats = [
  _ChatItem(
    id: 'c1',
    title: '产品例会',
    avatar: 'assets/group-chat.jpg',
    latestMessage: '本周 PRD 已同步，记得过目。',
    latestTime: '09:41',
    unread: 2,
    muted: false,
    online: true,
  ),
  _ChatItem(
    id: 'c2',
    title: '设计讨论',
    avatar: 'assets/avatar.png',
    latestMessage: '收到，晚上补充状态。',
    latestTime: '昨天',
    unread: 0,
    muted: true,
    online: true,
  ),
  _ChatItem(
    id: 'c3',
    title: '文件传输助手',
    avatar: 'assets/avatar-default.jpeg',
    latestMessage: '图片',
    latestTime: '昨天',
    unread: 0,
    muted: false,
    online: false,
  ),
  _ChatItem(
    id: 'c4',
    title: 'Call with Tim',
    avatar: 'assets/me.png',
    latestMessage: '[视频通话]',
    latestTime: '周三',
    unread: 5,
    muted: false,
    online: false,
  ),
  _ChatItem(
    id: 'c5',
    title: '客户反馈',
    avatar: 'assets/bella.jpeg',
    latestMessage: '素材已发，请查收。',
    latestTime: '周二',
    unread: 1,
    muted: false,
    online: false,
  ),
];
