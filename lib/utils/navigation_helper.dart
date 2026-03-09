import 'package:flutter/material.dart';

/// 导航辅助工具类
/// 用于处理 BottomNavigationBar 和 Navigator 混合使用的场景
class NavigationHelper {
  /// 安全返回：如果可以 pop 则 pop，否则导航到首页
  static void safePop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // 如果无法 pop，说明是通过 BottomNavigationBar 进入的，切换到首页
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  /// 检查当前页面是否可以通过 pop 返回
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// 智能返回：根据是否有 arguments 判断返回方式
  /// 如果有 arguments，说明是通过 pushNamed 进入的，应该 pop
  /// 如果没有 arguments，说明是通过 BottomNavigationBar 进入的，应该切换到首页
  ///
  /// 使用场景：
  /// - ChatPage: 从好友列表进入（有 arguments）应该 pop，从底部导航进入应该回首页
  /// - ProfilePage: 查看其他用户（有 arguments）应该 pop，查看自己应该回首页
  static void smartPop(BuildContext context, {String? defaultRoute}) {
    final route = ModalRoute.of(context);
    final hasArguments = route?.settings.arguments != null;

    if (hasArguments && Navigator.canPop(context)) {
      // 有参数且可以 pop，说明是通过 pushNamed 进入的
      Navigator.pop(context);
    } else {
      // 没有参数或无法 pop，说明是通过 BottomNavigationBar 进入的
      // 使用 pushReplacementNamed 避免栈积累
      Navigator.pushReplacementNamed(context, defaultRoute ?? '/home');
    }
  }

  /// 检查当前路由是否可以通过 pop 返回
  /// 用于决定是否显示返回按钮
  static bool shouldShowBackButton(BuildContext context) {
    final route = ModalRoute.of(context);
    final hasArguments = route?.settings.arguments != null;
    return hasArguments && Navigator.canPop(context);
  }
}
