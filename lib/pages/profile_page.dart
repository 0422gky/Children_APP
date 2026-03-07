import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  // 默认用户数据（当前用户）
  final User _currentUser = User(
    id: '0',
    name: '我',
    avatar: 'https://i.pravatar.cc/150?img=10',
    age: 8,
    interests: ['⚽ 足球', '🎮 游戏', '🧩 Lego'],
    location: '附近',
  );

  @override
  Widget build(BuildContext context) {
    // 如果传入了用户参数，显示该用户信息；否则显示当前用户信息
    final User? user = ModalRoute.of(context)?.settings.arguments as User?;
    final User displayUser = user ?? _currentUser;
    final bool isCurrentUser = user == null;

    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text(
          isCurrentUser ? '我的主页' : displayUser.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple[400],
        elevation: 0,
        actions: isCurrentUser
            ? [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 头像和基本信息
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.purple[400],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.purple[200],
                      backgroundImage: NetworkImage(displayUser.avatar),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayUser.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cake, color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${displayUser.age}岁',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        displayUser.location,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 兴趣标签
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎯 兴趣爱好',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: displayUser.interests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[200],
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // 如果是查看其他用户，显示操作按钮
            if (!isCurrentUser) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat', arguments: displayUser);
                        },
                        icon: const Icon(Icons.chat),
                        label: const Text('发送消息'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已发送好友申请')),
                          );
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('添加好友'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            // 如果是当前用户，显示更多信息
            if (isCurrentUser) ...[
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: const Text('我的活动'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(context, '/activity');
                  },
                ),
              ),
              const SizedBox(height: 12),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: const Icon(Icons.people, color: Colors.blue),
                  title: const Text('我的好友'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ),
              const SizedBox(height: 12),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: const Icon(Icons.family_restroom, color: Colors.green),
                  title: const Text('家长设置'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: isCurrentUser
          ? BottomNavigationBar(
              currentIndex: 3,
              selectedItemColor: Colors.purple[400],
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
                  icon: Icon(Icons.person),
                  label: '我的',
                ),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, '/home');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/chat');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/activity');
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(context, '/profile');
                    break;
                }
              },
            )
          : null,
    );
  }
}
