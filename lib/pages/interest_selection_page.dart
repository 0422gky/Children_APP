import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/current_user.dart';
import '../database/database_helper.dart';

class InterestSelectionPage extends StatefulWidget {
  const InterestSelectionPage({Key? key}) : super(key: key);

  @override
  State<InterestSelectionPage> createState() => _InterestSelectionPageState();
}

class _InterestSelectionPageState extends State<InterestSelectionPage> {
  // 分类列表
  final List<_InterestCategory> _categories = const [
    _InterestCategory(id: 'recommend', name: '推荐'),
    _InterestCategory(id: 'hobby', name: '爱好'),
    _InterestCategory(id: 'travel', name: '旅行'),
    _InterestCategory(id: 'life', name: '生活'),
    _InterestCategory(id: 'personality', name: '性格'),
    _InterestCategory(id: 'music', name: '音乐'),
    _InterestCategory(id: 'sport', name: '运动'),
    _InterestCategory(id: 'food', name: '美食'),
    _InterestCategory(id: 'pet', name: '宠物'),
    _InterestCategory(id: 'nature', name: '自然'),
    _InterestCategory(id: 'art', name: '艺术'),
    _InterestCategory(id: 'game', name: '游戏'),
  ];

  // 所有兴趣项（40+，按分类组织）
  late final List<_InterestItem> _allItems = [
    // 推荐
    const _InterestItem('recommend', '🌟 一起玩', '推荐'),
    const _InterestItem('recommend', '🤝 交新朋友', '推荐'),
    const _InterestItem('recommend', '🎉 派对聚会', '推荐'),
    const _InterestItem('recommend', '🏟 亲子活动', '推荐'),
    // 爱好
    const _InterestItem('hobby', '⚽ 足球', '爱好'),
    const _InterestItem('hobby', '🏀 篮球', '爱好'),
    const _InterestItem('hobby', '🎾 网球', '爱好'),
    const _InterestItem('hobby', '🏓 乒乓球', '爱好'),
    const _InterestItem('hobby', '🎨 画画', '爱好'),
    const _InterestItem('hobby', '🧩 拼图', '爱好'),
    const _InterestItem('hobby', '📚 阅读', '爱好'),
    const _InterestItem('hobby', '🎮 游戏', '爱好'),
    // 旅行
    const _InterestItem('travel', '🏖 海边玩水', '旅行'),
    const _InterestItem('travel', '⛰ 爬山徒步', '旅行'),
    const _InterestItem('travel', '🏕 露营野餐', '旅行'),
    const _InterestItem('travel', '🏙 城市探索', '旅行'),
    const _InterestItem('travel', '🚂 火车旅行', '旅行'),
    // 生活
    const _InterestItem('life', '🍳 一起做饭', '生活'),
    const _InterestItem('life', '🛒 逛超市', '生活'),
    const _InterestItem('life', '🧹 整理房间', '生活'),
    const _InterestItem('life', '🚌 上下学路上聊天', '生活'),
    // 性格
    const _InterestItem('personality', '😄 外向开朗', '性格'),
    const _InterestItem('personality', '🤫 安静内向', '性格'),
    const _InterestItem('personality', '🧠 爱思考', '性格'),
    const _InterestItem('personality', '🎭 爱表演', '性格'),
    const _InterestItem('personality', '🤹 爱尝试新鲜事物', '性格'),
    // 音乐
    const _InterestItem('music', '🎵 听流行歌', '音乐'),
    const _InterestItem('music', '🎹 钢琴', '音乐'),
    const _InterestItem('music', '🎻 小提琴', '音乐'),
    const _InterestItem('music', '🥁 打鼓', '音乐'),
    const _InterestItem('music', '🎤 唱歌', '音乐'),
    // 运动
    const _InterestItem('sport', '🚴 骑自行车', '运动'),
    const _InterestItem('sport', '🏊 游泳', '运动'),
    const _InterestItem('sport', '🤸 体操', '运动'),
    const _InterestItem('sport', '🏸 羽毛球', '运动'),
    const _InterestItem('sport', '🥋 跆拳道', '运动'),
    // 美食
    const _InterestItem('food', '🍕 披萨', '美食'),
    const _InterestItem('food', '🍣 寿司', '美食'),
    const _InterestItem('food', '🍰 蛋糕甜品', '美食'),
    const _InterestItem('food', '🍜 面条', '美食'),
    const _InterestItem('food', '🍎 健康水果', '美食'),
    // 宠物
    const _InterestItem('pet', '🐶 狗狗', '宠物'),
    const _InterestItem('pet', '🐱 猫咪', '宠物'),
    const _InterestItem('pet', '🐰 小兔子', '宠物'),
    const _InterestItem('pet', '🐹 仓鼠', '宠物'),
    const _InterestItem('pet', '🐦 小鸟', '宠物'),
    // 自然
    const _InterestItem('nature', '🌳 森林', '自然'),
    const _InterestItem('nature', '🌊 大海', '自然'),
    const _InterestItem('nature', '🌌 星空', '自然'),
    const _InterestItem('nature', '🌈 彩虹', '自然'),
    const _InterestItem('nature', '🌻 植物花草', '自然'),
    // 艺术
    const _InterestItem('art', '🎭 戏剧表演', '艺术'),
    const _InterestItem('art', '🎬 看电影', '艺术'),
    const _InterestItem('art', '📷 拍照', '艺术'),
    const _InterestItem('art', '🎧 听故事', '艺术'),
    // 游戏
    const _InterestItem('game', '🧩 桌游', '游戏'),
    const _InterestItem('game', '♟ 国际象棋', '游戏'),
    const _InterestItem('game', '🎮 主机游戏', '游戏'),
    const _InterestItem('game', '📱 手机小游戏', '游戏'),
  ];

  // 用户已选择的兴趣
  final Set<String> _selectedInterests = {};

  String _currentCategoryId = 'recommend';

  Future<void> _handleComplete() async {
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请至少选择一个兴趣爱好'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final currentUser = CurrentUser.user;
    if (currentUser == null || !currentUser.isChild) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('用户信息错误'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // 保存到数据库
      final interestsList = _selectedInterests.toList();
      await DatabaseHelper.instance.updateChildProfile(
        currentUser.id,
        {'interests_json': jsonEncode(interestsList)},
      );

      // 更新当前用户
      CurrentUser.setInterests(interestsList);

      // 跳转到首页
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('保存失败：${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text(
          '选择兴趣爱好',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple[400],
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 提示文字
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.orange[300]!,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange[800],
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '选择你喜欢的兴趣爱好，我们会为你推荐志同道合的小伙伴！',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange[900],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // 兴趣选择标题
                    Text(
                      '🎯 选择你的兴趣爱好',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 分类横向导航
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final bool selected = cat.id == _currentCategoryId;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentCategoryId = cat.id;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.purple[400]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? Colors.purple[600]!
                                      : Colors.purple[200]!,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  cat.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: selected
                                        ? Colors.white
                                        : Colors.purple[700],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 兴趣图片卡片网格
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final filtered = _allItems
                            .where((item) =>
                                item.categoryId == _currentCategoryId ||
                                _currentCategoryId == 'recommend')
                            .toList();
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: filtered.map((item) {
                            final String label = item.label;
                            final bool isSelected =
                                _selectedInterests.contains(label);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedInterests.remove(label);
                                  } else {
                                    _selectedInterests.add(label);
                                  }
                                });
                              },
                              child: _InterestCard(
                                label: label,
                                categoryName: item.categoryName,
                                selected: isSelected,
                                width:
                                    (constraints.maxWidth - 12) / 2, // 两列布局
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // 已选择提示
                    if (_selectedInterests.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.green[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '已选择 ${_selectedInterests.length} 个兴趣',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // 完成按钮
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    '完成',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InterestCategory {
  final String id;
  final String name;

  const _InterestCategory({
    required this.id,
    required this.name,
  });
}

class _InterestItem {
  final String categoryId;
  final String label;
  final String categoryName;

  const _InterestItem(this.categoryId, this.label, this.categoryName);
}

class _InterestCard extends StatelessWidget {
  final String label;
  final String categoryName;
  final bool selected;
  final double width;

  const _InterestCard({
    Key? key,
    required this.label,
    required this.categoryName,
    required this.selected,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = selected
        ? [Colors.purple[400]!, Colors.purple[600]!]
        : [Colors.orange[200]!, Colors.pink[200]!];

    return Container(
      width: width.clamp(140, 260),
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 模拟图片的浅色叠层
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            right: 12,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Row(
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  categoryName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

