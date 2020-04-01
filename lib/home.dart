import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'CompletedPage.dart';
import 'DroppedPage.dart';
import 'PlantoWatchPage.dart';
import 'WatchingPage.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.arrow_upward), title: Text("Watching")),
          BottomNavigationBarItem(icon: Icon(Icons.check), title: Text("Completed")),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text("Add")),
          BottomNavigationBarItem(icon: Icon(Icons.delete), title: Text("Dropped")),
          BottomNavigationBarItem(icon: Icon(Icons.note), title: Text("Plan to Watch"))
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        ),
    );
  }
  }