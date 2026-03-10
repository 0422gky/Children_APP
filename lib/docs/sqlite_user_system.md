# SQLite 用户系统实现文档

## 概述

本系统实现了完整的本地 SQLite 用户系统，支持用户注册、登录、绑定码生成和绑定功能。

## 数据库结构

### 表结构

#### 1. users 表
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL,  -- 'parent' 或 'child'
  created_at TEXT NOT NULL
)
```

#### 2. parent_profiles 表
```sql
CREATE TABLE parent_profiles (
  user_id TEXT PRIMARY KEY,
  parent_name TEXT NOT NULL,
  phone TEXT,
  bind_code TEXT,  -- 6位绑定码
  FOREIGN KEY (user_id) REFERENCES users (id)
)
```

#### 3. child_profiles 表
```sql
CREATE TABLE child_profiles (
  user_id TEXT PRIMARY KEY,
  child_name TEXT NOT NULL,
  age INTEGER NOT NULL,
  interests_json TEXT,  -- JSON 格式的兴趣列表
  parent_user_id TEXT,  -- 绑定的家长ID
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (parent_user_id) REFERENCES users (id)
)
```

#### 4. bindings 表
```sql
CREATE TABLE bindings (
  id TEXT PRIMARY KEY,
  parent_user_id TEXT NOT NULL,
  child_user_id TEXT NOT NULL,
  bind_code TEXT NOT NULL,
  status TEXT NOT NULL,  -- 'pending' 或 'approved'
  FOREIGN KEY (parent_user_id) REFERENCES users (id),
  FOREIGN KEY (child_user_id) REFERENCES users (id)
)
```

## 文件结构

### 数据模型 (`lib/models/`)

1. **`db_user.dart`** - 数据库用户模型
   - `DbUser` 类：用于数据库存储的用户模型
   - `fromMap()` / `toMap()` 方法

2. **`db_parent_profile.dart`** - 家长资料模型
   - `DbParentProfile` 类：家长资料
   - 包含绑定码字段

3. **`db_child_profile.dart`** - 儿童资料模型
   - `DbChildProfile` 类：儿童资料
   - 兴趣列表使用 JSON 存储

4. **`db_binding.dart`** - 绑定关系模型
   - `DbBinding` 类：绑定关系

### 数据库层 (`lib/database/`)

**`database_helper.dart`** - 数据库辅助类
- 单例模式
- 数据库初始化和表创建
- 提供所有表的 CRUD 操作
- 所有方法都是异步的

### 服务层 (`lib/services/`)

1. **`auth_service.dart`** - 认证服务
   - `register()`: 注册用户
   - `login()`: 用户登录
   - `getParentProfile()`: 获取家长资料
   - `getChildProfile()`: 获取儿童资料
   - 密码使用 SHA256 哈希

2. **`binding_service.dart`** - 绑定服务
   - `generateBindCode()`: 生成绑定码
   - `getOrGenerateBindCode()`: 获取或生成绑定码
   - `bindChildToParent()`: 儿童绑定家长
   - `getChildrenByParent()`: 获取家长绑定的所有儿童
   - `getParentByChild()`: 获取儿童绑定的家长

## 使用示例

### 1. 用户注册

```dart
import '../services/auth_service.dart';

final authService = AuthService.instance;

// 注册家长
final parentUser = await authService.register(
  username: 'parent123',
  password: 'password123',
  role: 'parent',
  parentName: '张爸爸',
);

// 注册儿童
final childUser = await authService.register(
  username: 'child123',
  password: 'password123',
  role: 'child',
  childName: '小明',
  age: 8,
);
```

### 2. 用户登录

```dart
final authService = AuthService.instance;

final user = await authService.login('parent123', 'password123');
if (user != null) {
  // 登录成功
  print('登录成功：${user.username}, 角色：${user.role}');
} else {
  // 登录失败
  print('用户名或密码错误');
}
```

### 3. 生成绑定码（家长端）

```dart
import '../services/binding_service.dart';

final bindingService = BindingService.instance;
final currentUser = CurrentUser.user; // 当前登录的家长

// 生成绑定码
final bindCode = await bindingService.generateBindCode(currentUser.id);
print('绑定码：$bindCode');
```

### 4. 儿童绑定家长

```dart
final bindingService = BindingService.instance;
final currentUser = CurrentUser.user; // 当前登录的儿童

// 输入绑定码
final success = await bindingService.bindChildToParent(
  currentUser.id,
  '123456', // 绑定码
);

if (success) {
  print('绑定成功！');
} else {
  print('绑定失败：绑定码无效或已使用');
}
```

### 5. 查询绑定关系

```dart
// 家长查询绑定的所有儿童
final children = await bindingService.getChildrenByParent(parentUserId);
for (final child in children) {
  print('绑定的儿童：${child.childName}, 年龄：${child.age}');
}

// 儿童查询绑定的家长
final parentId = await bindingService.getParentByChild(childUserId);
if (parentId != null) {
  print('已绑定家长：$parentId');
}
```

## 页面集成

### 登录页面 (`lib/pages/login_page.dart`)

- 支持登录和注册
- 根据选择的角色显示不同的注册字段
- 登录成功后根据角色跳转到不同页面

### 绑定码页面 (`lib/pages/binding_code_page.dart`)

- 家长端：生成和显示绑定码
- 儿童端：输入绑定码完成绑定

### 兴趣选择页面 (`lib/pages/interest_selection_page.dart`)

- 选择兴趣后保存到数据库
- 使用 JSON 格式存储兴趣列表

## 密码安全

- 使用 SHA256 哈希算法
- 密码明文不会存储到数据库
- 登录时比较哈希值

## 注意事项

1. **数据库初始化**
   - 首次运行时会自动创建数据库和表
   - 数据库文件存储在应用的数据库目录

2. **异步操作**
   - 所有数据库操作都是异步的
   - 使用 `await` 等待操作完成

3. **错误处理**
   - 注册时检查用户名是否已存在
   - 绑定码验证失败时返回 false
   - 所有操作都应该用 try-catch 包裹

4. **数据同步**
   - 数据库操作完成后，需要更新 `CurrentUser`
   - UI 层使用 `FutureBuilder` 异步加载数据

## 测试建议

1. **注册测试**
   - 注册家长用户
   - 注册儿童用户
   - 测试用户名重复的情况

2. **登录测试**
   - 使用正确的用户名和密码
   - 使用错误的密码
   - 使用不存在的用户名

3. **绑定测试**
   - 家长生成绑定码
   - 儿童使用正确的绑定码绑定
   - 儿童使用错误的绑定码
   - 测试重复绑定（应该失败）

4. **数据持久化测试**
   - 注册后关闭应用，重新打开应该能登录
   - 绑定关系应该持久保存
