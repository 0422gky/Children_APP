import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/mock_parent_data.dart';
import '../models/approval_request.dart';
import '../widgets/screen_time_banner.dart';
import '../utils/navigation_helper.dart';
import '../utils/image_provider_helper.dart';

class ActivityPage extends StatefulWidget {
  ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  // 假数据：活动列表
  final List<Activity> _activities = [
    Activity(
      id: '1',
      title: '一起踢足球',
      description: '周六下午在公园踢足球，欢迎喜欢足球的小朋友加入！',
      date: '2024-01-20',
      time: '14:00',
      location: '中央公园',
      organizerId: '1',
      organizerName: '小明',
      organizerAvatar: 'assets/images/Avatar1.png',
      participantIds: ['1', '2'],
      maxParticipants: 6,
      interest: '⚽ 足球',
      image: 'assets/images/football.jpg',
    ),
    Activity(
      id: '2',
      title: 'Lego 创意搭建',
      description: '一起用 Lego 搭建城堡，发挥想象力！',
      date: '2024-01-21',
      time: '15:00',
      location: '社区活动中心',
      organizerId: '3',
      organizerName: '小刚',
      organizerAvatar: 'assets/images/Avatar2.png',
      participantIds: ['3', '4'],
      maxParticipants: 8,
      interest: '🧩 Lego',
      image: 'assets/images/lego.jpg',
    ),
    Activity(
      id: '3',
      title: '画画小课堂',
      description: '一起学习画画，画出美丽的风景！',
      date: '2024-01-22',
      time: '10:00',
      location: '艺术教室',
      organizerId: '2',
      organizerName: '小红',
      organizerAvatar: 'assets/images/Avatar4.png',
      participantIds: ['2'],
      maxParticipants: 5,
      interest: '🎨 画画',
      image: 'assets/images/drawing.jpg',
    ),
  ];

  ApprovalStatus? _getStatus(String activityId) {
    return MockParentData.getStatusByActivityId(activityId);
  }

  String _buildStatusText(ApprovalStatus? status) {
    if (status == null) {
      return '尚未发起家长审批';
    }
    switch (status) {
      case ApprovalStatus.pending:
        return '审批状态：待家长确认';
      case ApprovalStatus.approved:
        return '审批状态：家长已同意';
      case ApprovalStatus.rejected:
        return '审批状态：家长已拒绝';
    }
  }

  Color? _statusColor(ApprovalStatus? status) {
    if (status == null) {
      return Colors.grey[600];
    }
    switch (status) {
      case ApprovalStatus.pending:
        return Colors.orange[700];
      case ApprovalStatus.approved:
        return Colors.green[700];
      case ApprovalStatus.rejected:
        return Colors.red[700];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          '活动广场',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.orange[400],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/create-activity');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activities.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const ScreenTimeBanner();
          }
          final activity = _activities[index - 1];
          final status = _getStatus(activity.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            child: InkWell(
              onTap: () {
                // 可以跳转到活动详情页
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(activity.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.orange[200],
                          backgroundImage: getImageProvider(activity.organizerAvatar),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.organizerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '发起了活动',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            activity.interest,
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activity.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${activity.date} ${activity.time}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          activity.location,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _buildStatusText(status),
                      style: TextStyle(
                        color: _statusColor(status),
                        fontSize: 13,
                        fontWeight:
                            status == null ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${activity.currentParticipants}/${activity.maxParticipants} 人参加',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _buildButtonEnabled(activity, status)
                              ? () {
                                  MockParentData.createActivityRequest(
                                    activityId: activity.id,
                                    activityTitle: activity.title,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('已发送家长确认'),
                                    ),
                                  );
                                  setState(() {});
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            _buildButtonText(activity, status),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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

  bool _buildButtonEnabled(Activity activity, ApprovalStatus? status) {
    if (!activity.hasSpace) {
      return false;
    }
    if (status == null) {
      return true;
    }
    switch (status) {
      case ApprovalStatus.pending:
      case ApprovalStatus.approved:
      case ApprovalStatus.rejected:
        return false;
    }
  }

  String _buildButtonText(Activity activity, ApprovalStatus? status) {
    if (!activity.hasSpace) {
      return '名额已满';
    }
    if (status == null) {
      return '加入活动';
    }
    switch (status) {
      case ApprovalStatus.pending:
        return '等待审批';
      case ApprovalStatus.approved:
        return '已同意';
      case ApprovalStatus.rejected:
        return '已拒绝';
    }
  }
}
