import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
        ),
        scaffoldBackgroundColor: Color(0xfff5f5f5),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Color(0xff707070)),
        ),
      ),
      home: HomePage(),
    );
  }
}
