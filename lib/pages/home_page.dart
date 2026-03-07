import 'package:flutter/material.dart';
import '../models/user.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // 假数据：好友列表
  final List<User> _friends = [
    User(
      id: '1',
      name: '小明',
      avatar: 'https://i.pravatar.cc/150?img=1',
      age: 8,
      interests: ['⚽ 足球', '🎮 游戏'],
      location: '附近 500m',
    ),
    User(
      id: '2',
      name: '小红',
      avatar: 'https://i.pravatar.cc/150?img=2',
      age: 7,
      interests: ['🎨 画画', '📚 阅读'],
      location: '附近 1km',
    ),
    User(
      id: '3',
      name: '小刚',
      avatar: 'https://i.pravatar.cc/150?img=3',
      age: 9,
      interests: ['🧩 Lego', '⚽ 足球'],
      location: '附近 800m',
    ),
  ];

  // 假数据：兴趣匹配
  final Map<String, List<User>> _interestMatches = {
    '⚽ 足球': [
      User(
        id: '4',
        name: '小强',
        avatar: 'https://i.pravatar.cc/150?img=4',
        age: 8,
        interests: ['⚽ 足球', '🎮 游戏'],
        location: '附近 600m',
      ),
      User(
        id: '5',
        name: '小美',
        avatar: 'https://i.pravatar.cc/150?img=5',
        age: 7,
        interests: ['⚽ 足球', '🎨 画画'],
        location: '附近 1.2km',
      ),
    ],
    '🧩 Lego': [
      User(
        id: '6',
        name: '小乐',
        avatar: 'https://i.pravatar.cc/150?img=6',
        age: 8,
        interests: ['🧩 Lego', '📚 阅读'],
        location: '附近 900m',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          '我的好友',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple[400],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 兴趣匹配区域
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎯 兴趣匹配',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _interestMatches.length,
                      itemBuilder: (context, index) {
                        final interest = _interestMatches.keys.elementAt(index);
                        final users = _interestMatches[interest]!;
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                interest,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, idx) {
                                    final user = users[idx];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.purple[200],
                                        backgroundImage: NetworkImage(user.avatar),
                                      ),
                                      title: Text(user.name),
                                      subtitle: Text('${user.age}岁 · ${user.location}'),
                                      onTap: () {
                                        Navigator.pushNamed(context, '/profile', arguments: user);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 好友列表
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '👥 我的好友',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.purple[200],
                      backgroundImage: NetworkImage(friend.avatar),
                    ),
                    title: Text(
                      friend.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${friend.age}岁 · ${friend.location}'),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          children: friend.interests.map((interest) {
                            return Chip(
                              label: Text(interest),
                              backgroundColor: Colors.orange[100],
                              labelStyle: const TextStyle(fontSize: 12),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      color: Colors.purple[400],
                      onPressed: () {
                        Navigator.pushNamed(context, '/chat', arguments: friend);
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile', arguments: friend);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.purple[400],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
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
              Navigator.pushReplacementNamed(context, '/activity');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
