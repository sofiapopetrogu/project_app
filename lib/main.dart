import 'package:flutter/material.dart';
import 'package:project_app/screens/loginpage.dart';

void main() {
  runApp(const MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
          return MaterialApp(
            home: LoginPage()
          );
  } //build
}//MyApp