# 环境搭建
vscode 安装 flutter dart 插件

# dart 语法, flutter 快速入门
1. 旦夕教程
https://github.com/DanXi-Dev/QuickStart/blob/main/Flutter%20%E6%8A%80%E6%9C%AF%E6%A0%88%E5%BF%AB%E9%80%9F%E4%B8%8A%E6%89%8B.md
（我们不需要Android Studio，只用vscode就可以了）
2. 中文社区教程
https://docs.flutter.cn/install

3. flutter 英文社区教程
https://docs.flutter.dev/learn/pathway/tutorial/create-an-app

4. 不懂的可以问GPT / Google， 或者群里讨论

5. 代码多问问AI， Cursor之类的平台写这种demo很方便

# 项目结构

```
lib/
├── main.dart                    # 应用入口和路由配置
├── models/
│   ├── user.dart               # 用户数据模型
│   └── activity.dart           # 活动数据模型
├── widgets/
│   └── chat_bubble.dart        # 聊天气泡组件
└── pages/
    ├── login_page.dart         # 登录/注册页面
    ├── home_page.dart          # 首页（好友列表 + 兴趣匹配）
    ├── chat_page.dart          # 聊天页面
    ├── activity_page.dart      # 活动列表页面
    ├── create_activity_page.dart # 发起活动页面
    └── profile_page.dart       # 个人主页
```

# 运行方式
1. 安装 Flutter SDK
2. 在项目目录运行 
```bash
flutter pub get
flutter run
```

所有页面使用假数据，可直接运行。页面间通过 Navigator.pushNamed 跳转，路由配置在 main.dart 中统一管理

# 报错信息

1. flutter pub get 需要很多时间运行
可以在终端当中设置自己的代理环境变量 / 用国内的flutter 源

e.g.

```bash
PS D:\Codefield\Social_APP> $env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
PS D:\Codefield\Social_APP> $env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

2. flutter run 没找到支持的运行平台
例如下面
```
Flutter assets will be downloaded from https://storage.flutter-io.cn. Make
sure you trust this source!
No supported devices connected.

The following devices were found, but are not supported by this project:     
Windows (desktop) • windows • windows-x64    • Microsoft Windows [版本       
10.0.22631.6199]
Chrome (web)      • chrome  • web-javascript • Google Chrome 145.0.7632.119  
Edge (web)        • edge    • web-javascript • Microsoft Edge 145.0.3800.82 
```

运行下面命令即可
```bash
flutter create .
```

