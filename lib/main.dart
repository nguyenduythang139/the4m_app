import 'package:flutter/material.dart';
import 'package:the4m_app/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: HomeScreen())),
      debugShowCheckedModeBanner: false,
    );
  }
}
