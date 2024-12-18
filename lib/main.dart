import 'package:diu_result/screens/results_screen.dart';
import 'package:diu_result/screens/student_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Results',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        elevatedButtonTheme: _elevatedButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        appBarTheme: buildAppBarTheme(),
        tabBarTheme: buildTabBarTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StudentInputScreen(),
        '/results': (context) => ResultsScreen(),
      },
    );
  }

  AppBarTheme buildAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.blueAccent,
    );
  }

  TabBarTheme buildTabBarTheme() {
    return const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      indicatorColor: Colors.white,
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      border: _inputBorder(),
      focusedBorder: _inputBorder(),
      enabledBorder: _inputBorder(),
      disabledBorder: _inputBorder(),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      labelStyle: const TextStyle(
        color: Colors.blueAccent,
      ),
    );
  }

  OutlineInputBorder _inputBorder() {
    return const OutlineInputBorder(
      // border color
      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
      borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      ),
    );
  }

  ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      fixedSize: const Size.fromWidth(double.maxFinite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      elevation: 2,
    ));
  }
}
