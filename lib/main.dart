import 'package:flutter/material.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/login_screen.dart';
import 'package:the4m_app/screens/waiting_screen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: WaitingScreen())),
      debugShowCheckedModeBanner: false,
    );
  }
}
