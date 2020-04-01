import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jiyu",
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        brightness: Brightness.dark
      ),
      home: HomePage()
    );
  }
}

