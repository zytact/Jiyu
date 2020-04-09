import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'CompletedPage.dart';
import 'DroppedPage.dart';
import 'PlantoWatchPage.dart';
import 'WatchingPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List tabs = [
    WatchingPage(),
    CompletedPage(),
    AddPage(),
    DroppedPage(),
    PlantoWatchPage()
  ];
  List<Color> color = [
    Colors.green,
    Colors.blue,
    Colors.greenAccent,
    Colors.red,
    Colors.grey
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: color[_currentIndex],
        backgroundColor: const Color(0xFF333333),
        buttonBackgroundColor: color[_currentIndex],
        index: _currentIndex,
        height: 50,
        items: [
          Icon(Icons.arrow_upward),
          Icon(Icons.check),
          Icon(Icons.add),
          Icon(Icons.delete),
          Icon(Icons.note),
        ],
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(milliseconds: 200),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
