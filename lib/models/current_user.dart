import 'user.dart';

/// 当前用户数据管理（使用静态变量模拟，实际项目中应使用 SharedPreferences 或数据库）
class CurrentUser {
  static User? _user;
  static bool _hasSelectedInterests = false;

  /// 获取当前用户
  static User? get user => _user;

  /// 是否已选择兴趣
  static bool get hasSelectedInterests => _hasSelectedInterests;

  /// 设置当前用户
  static void setUser(User user) {
    _user = user;
  }

  /// 设置用户兴趣
  static void setInterests(List<String> interests) {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        name: _user!.name,
        avatar: _user!.avatar,
        age: _user!.age,
        interests: interests,
        location: _user!.location,
      );
      _hasSelectedInterests = true;
    }
  }

  /// 初始化默认用户（用于测试）
  static void initDefaultUser() {
    _user = User(
      id: '0',
      name: '我',
      avatar: 'https://i.pravatar.cc/150?img=10',
      age: 8,
      interests: [], // 初始为空，需要选择
      location: '附近',
    );
    _hasSelectedInterests = false;
  }

  /// 重置（用于登出）
  static void reset() {
    _user = null;
    _hasSelectedInterests = false;
  }
}
