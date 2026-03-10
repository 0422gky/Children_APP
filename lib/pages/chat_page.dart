import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/chat_bubble.dart';
import '../utils/navigation_helper.dart';
import '../widgets/screen_time_banner.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  // 假数据：消息列表
  final List<Map<String, dynamic>> _messages = [
    {
      'message': '你好！你想一起踢足球吗？',
      'isMe': false,
      'time': '10:30',
    },
    {
      'message': '好啊！什么时候？',
      'isMe': true,
      'time': '10:32',
    },
    {
      'message': '周六下午怎么样？在公园里！',
      'isMe': false,
      'time': '10:33',
    },
    {
      'message': '太好了！我让我妈妈同意一下！',
      'isMe': true,
      'time': '10:35',
    },
    {
      'message': '好的，等你消息！😊',
      'isMe': false,
      'time': '10:36',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final User? friend = ModalRoute.of(context)?.settings.arguments as User?;
    final String friendName = friend?.name ?? '好友';
    final String friendAvatar =
        friend?.avatar ?? 'assets/images/avatar1.png'; // asset
    const String myAvatar = 'assets/images/avatar1.png'; // asset

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.purple[200],
              backgroundImage: NetworkImage(friendAvatar),
            ),
            const SizedBox(width: 12),
            Text(
              friendName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple[400],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 智能返回：如果有 arguments（从好友列表进入），则 pop；否则切换到首页
            NavigationHelper.smartPop(context, defaultRoute: '/home');
          },
        ),
      ),
      body: Column(
        children: [
          const ScreenTimeBanner(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubble(
                  message: msg['message'] as String,
                  isMe: msg['isMe'] as bool,
                  avatar: msg['isMe'] as bool ? myAvatar : friendAvatar,
                );
              },
            ),
          ),
          // 输入框
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: '输入消息...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple[400],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.orange[400],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '聊天',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: '活动',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: '家长',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        onTap: (index) {
          NavigationHelper.goToTab(context, index);
        },
      ),
    );
  }
}
