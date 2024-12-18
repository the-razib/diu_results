import 'package:diu_result/screens/results_screen.dart';
import 'package:diu_result/screens/student_input_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Results',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StudentInputScreen(),
        '/results': (context) => ResultsScreen(),
      },
    );
  }
}
