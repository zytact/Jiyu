import 'package:flutter/material.dart';
import 'WatchingPage.dart';

void main() => runApp(Jiyu());

class Jiyu extends StatelessWidget {
  final backgroundColor = Color(0xFF33325F);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Jiyu",
        theme: ThemeData(
          primarySwatch: Colors.purple,
          brightness: Brightness.dark,
          canvasColor: backgroundColor,
        ),
        home: WatchingPage());
  }
}
