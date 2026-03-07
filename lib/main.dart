import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/chat_page.dart';
import 'pages/activity_page.dart';
import 'pages/create_activity_page.dart';
import 'pages/profile_page.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => HomePage(),
        '/chat': (context) => ChatPage(),
        '/activity': (context) => ActivityPage(),
        '/create-activity': (context) => const CreateActivityPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
