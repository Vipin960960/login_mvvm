import 'package:flutter/material.dart';
import 'package:login_mvvm/screens/signup_screen.dart';
import 'package:login_mvvm/utils/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const androidMethodChannel = 'androidMethodChannel';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: teal_700Material,
      ),
      home: const SignupScreen(),
    );
  }
}
