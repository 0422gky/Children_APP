# 双身份系统设计文档

## 概述

本系统实现了家长端和儿童端的双身份体系，包括身份选择、登录流程和绑定机制。

## 系统架构

### 1. 数据模型

#### User 模型 (`lib/models/user.dart`)
```dart
enum UserRole {
  parent, // 家长
  child,  // 儿童
}

class User {
  final String id;
  final String name;
  final String avatar;
  final int age;
  final List<String> interests;
  final String location;
  final UserRole role; // 用户角色
}
```

#### 绑定码模型 (`lib/models/binding.dart`)
- `BindingCode`: 绑定码模型（6位数字码，24小时有效）
- `Binding`: 绑定关系模型
- `BindingCodeManager`: 绑定码管理类（静态方法，模拟数据库）

### 2. 页面流程

```
启动 App
  ↓
RoleSelectPage (身份选择)
  ├─ 选择"我是家长" → 初始化家长用户 → LoginPage
  └─ 选择"我是小朋友" → 初始化儿童用户 → LoginPage
  ↓
LoginPage (登录/注册)
  ├─ 家长用户 → ParentHomePage
  └─ 儿童用户 → InterestSelectionPage → HomePage
```

### 3. 绑定流程

#### 家长端生成绑定码
1. 进入 ParentHomePage
2. 点击"生成绑定码"
3. 进入 BindingCodePage (isParent = true)
4. 生成6位绑定码
5. 复制绑定码给儿童

#### 儿童端输入绑定码
1. 进入 ProfilePage
2. 点击"未绑定家长"卡片
3. 进入 BindingCodePage (isParent = false)
4. 输入6位绑定码
5. 确认绑定

## 文件结构

### 新增文件

1. **`lib/models/binding.dart`**
   - 绑定码和绑定关系的数据模型
   - BindingCodeManager 管理类

2. **`lib/pages/role_select_page.dart`**
   - 身份选择页面（首次进入时选择家长/儿童）

3. **`lib/pages/binding_code_page.dart`**
   - 绑定码生成/输入页面
   - 根据 isParent 参数显示不同界面

### 修改的文件

1. **`lib/models/user.dart`**
   - 添加 `UserRole` 枚举
   - 添加 `role` 字段

2. **`lib/models/current_user.dart`**
   - 添加 `initDefaultParentUser()` 方法
   - 添加 `initDefaultChildUser()` 方法
   - 添加 `isParent` 和 `isChild` 属性

3. **`lib/pages/login_page.dart`**
   - 修改登录逻辑，根据角色跳转到不同页面

4. **`lib/pages/parent_home_page.dart`**
   - 添加绑定管理卡片
   - 显示已绑定的儿童数量
   - 添加"生成绑定码"按钮

5. **`lib/pages/profile_page.dart`**
   - 添加绑定状态显示
   - 添加绑定码输入入口

6. **`lib/pages/home_page.dart`**
   - 修复所有 User 创建，添加 role 参数

7. **`lib/main.dart`**
   - 修改初始路由为 `/role-select`
   - 添加 `/binding-code` 路由

## 使用流程

### 家长端流程

1. **首次使用**
   - 启动 App → 选择"我是家长" → 登录 → 进入 ParentHomePage

2. **生成绑定码**
   - 在 ParentHomePage 点击"生成绑定码"
   - 生成6位绑定码
   - 复制绑定码给儿童

3. **查看绑定状态**
   - ParentHomePage 显示"已绑定 X 个儿童账号"

### 儿童端流程

1. **首次使用**
   - 启动 App → 选择"我是小朋友" → 登录 → 选择兴趣 → 进入 HomePage

2. **绑定家长**
   - 在 ProfilePage 点击"未绑定家长"
   - 输入家长提供的6位绑定码
   - 确认绑定

3. **查看绑定状态**
   - ProfilePage 显示绑定状态（已绑定/未绑定）

## 绑定码机制

### 特性
- 6位数字码
- 24小时有效期
- 一次性使用（使用后失效）
- 每个家长可以生成多个绑定码

### 验证逻辑
1. 检查绑定码是否存在
2. 检查是否已使用
3. 检查是否过期
4. 检查是否已绑定（避免重复绑定）

## 数据存储

当前使用静态变量模拟数据存储：
- `BindingCodeManager._bindingCodes`: 存储所有绑定码
- `BindingCodeManager._bindings`: 存储所有绑定关系

实际项目中应使用：
- SharedPreferences（本地存储）
- 数据库（SQLite/Hive）
- 后端 API（真实项目）

## 注意事项

1. **角色区分**
   - 所有 User 对象必须包含 role 字段
   - 创建假数据时注意添加 role 参数

2. **路由管理**
   - 初始路由为 `/role-select`
   - 登录后根据角色跳转到不同页面

3. **绑定状态**
   - 绑定关系存储在 BindingCodeManager 中
   - 页面刷新时需要重新获取绑定状态

4. **向后兼容**
   - 保留了 `initDefaultUser()` 方法（默认创建儿童用户）
   - 但建议使用 `initDefaultChildUser()` 或 `initDefaultParentUser()`

## 测试建议

1. **测试身份选择**
   - 选择家长身份，验证跳转到登录页
   - 选择儿童身份，验证跳转到登录页

2. **测试登录流程**
   - 家长登录后应进入 ParentHomePage
   - 儿童登录后应进入兴趣选择或 HomePage

3. **测试绑定流程**
   - 家长生成绑定码
   - 儿童输入绑定码
   - 验证绑定成功
   - 验证绑定状态显示

4. **测试边界情况**
   - 输入错误的绑定码
   - 输入过期的绑定码
   - 重复绑定（应该失败）
