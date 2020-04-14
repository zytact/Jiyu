import 'package:flutter/material.dart';
import 'WatchingPage.dart';

void main() => runApp(Jiyu());

class Jiyu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Jiyu",
        theme: ThemeData(
            primarySwatch: Colors.lightGreen, brightness: Brightness.dark),
        home: WatchingPage());
  }
}
