import 'package:flutter/material.dart';
import 'package:mike_family_tree/screens/login_screen.dart';
import 'package:mike_family_tree/screens/view_family_screen.dart';

void main() {
  runApp( FamilyTreeApp());
}

class FamilyTreeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Tree App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginScreen(),
    );
  }
}
