# Flutter 导航最佳实践

## 问题场景

在使用 BottomNavigationBar + Navigator 混合导航时，会遇到以下问题：

1. **主页面通过 BottomNavigationBar 切换**：使用 `pushReplacementNamed`，不压栈
2. **子页面通过 pushNamed 进入**：使用 `pushNamed`，压栈
3. **返回按钮行为不一致**：需要判断是 pop 还是切换页面

## 解决方案

### 1. 使用 NavigationHelper 工具类

创建了 `lib/utils/navigation_helper.dart` 工具类，提供以下方法：

- `safePop(context)`: 安全返回，如果可以 pop 则 pop，否则导航到首页
- `smartPop(context, defaultRoute)`: 智能返回，根据是否有 arguments 判断返回方式

### 2. 导航规则

#### 主页面（带 BottomNavigationBar）
- 使用 `pushReplacementNamed` 切换，避免栈积累
- 每个主页面都有 BottomNavigationBar
- 通过 BottomNavigationBar 切换时，使用 `pushReplacementNamed`

#### 子页面（不带 BottomNavigationBar）
- 使用 `pushNamed` 进入，压栈
- 返回时使用 `Navigator.pop()`
- 例如：CreateActivityPage、查看其他用户的 ProfilePage

#### 混合页面（ChatPage、ProfilePage）
- 既可以通过 BottomNavigationBar 切换显示
- 也可以通过 pushNamed 进入（带 arguments）
- 返回逻辑：
  ```dart
  // 如果有 arguments，说明是通过 pushNamed 进入的，应该 pop
  // 如果没有 arguments，说明是通过 BottomNavigationBar 进入的，应该切换到首页
  NavigationHelper.smartPop(context, defaultRoute: '/home');
  ```

### 3. 判断进入方式

通过检查 `ModalRoute.of(context)?.settings.arguments` 来判断：

- **有 arguments**：通过 `pushNamed` 进入，应该 `pop`
- **无 arguments**：通过 BottomNavigationBar 进入，应该 `pushReplacementNamed` 到首页

### 4. 代码示例

#### ChatPage 返回按钮
```dart
leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () {
    NavigationHelper.smartPop(context, defaultRoute: '/home');
  },
),
```

#### ProfilePage 返回按钮（查看其他用户时）
```dart
leading: isCurrentUser
    ? null
    : IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          NavigationHelper.smartPop(context, defaultRoute: '/home');
        },
      ),
```

## 页面层级结构

```
登录页 (LoginPage)
  ↓ (pushReplacementNamed)
主页面层 (带 BottomNavigationBar)
  ├─ HomePage
  ├─ ChatPage (混合页面)
  ├─ ActivityPage
  ├─ ParentPage
  └─ ProfilePage (混合页面)
      ↓ (pushNamed，带 arguments)
      子页面层
        ├─ ChatPage (与好友聊天)
        ├─ ProfilePage (查看其他用户)
        └─ CreateActivityPage
```

## 注意事项

1. **避免重复压栈**：主页面之间切换使用 `pushReplacementNamed`
2. **检查 canPop**：使用 `Navigator.canPop(context)` 检查是否可以 pop
3. **统一返回逻辑**：使用 NavigationHelper 统一处理返回逻辑
4. **测试场景**：
   - 从 BottomNavigationBar 进入 ChatPage，点击返回 → 应该回到首页
   - 从好友列表 pushNamed 进入 ChatPage，点击返回 → 应该 pop 回好友列表
