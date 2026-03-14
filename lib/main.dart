import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/chat_page.dart';
import 'pages/activity_page.dart';
import 'pages/create_activity_page.dart';
import 'pages/profile_page.dart';
import 'pages/interest_selection_page.dart';
import 'pages/personality_selection_page.dart';
import 'pages/interest_category_selection_page.dart';
import 'pages/role_select_page.dart';
import 'pages/binding_code_page.dart';
import 'models/current_user.dart';
import 'pages/parent_home_page.dart';
import 'pages/approval_list_page.dart';
import 'pages/safety_page.dart';
import 'pages/screen_time_limit_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '儿童社交 App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: '/role-select',
      routes: {
        '/role-select': (context) => const RoleSelectPage(),
        '/login': (context) => const LoginPage(),
        '/interest-category-selection': (context) => const InterestCategorySelectionPage(),
        '/interest-selection': (context) => const InterestSelectionPage(),
        '/personality-selection': (context) => const PersonalitySelectionPage(),
        '/home': (context) => HomePage(),
        '/chat': (context) => ChatPage(),
        '/activity': (context) => ActivityPage(),
        '/create-activity': (context) => const CreateActivityPage(),
        '/profile': (context) => ProfilePage(),
        '/parent': (context) => const ParentHomePage(),
        '/approval-list': (context) => const ApprovalListPage(),
        '/safety': (context) => const SafetyPage(),
        '/screen-time-limit': (context) => const ScreenTimeLimitPage(),
        '/binding-code': (context) {
          final isParent = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
          return BindingCodePage(isParent: isParent);
        },
      },
    );
  }
}
