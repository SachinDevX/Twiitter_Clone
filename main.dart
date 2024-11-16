import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'features/auth/screens/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Clone',
      theme: ThemeData.dark(),
      home: const HomeScreen(), // Use the correct HomeScreen
    );
  }
}
