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
  List<Widget> tabs = [
    WatchingPage(),
    CompletedPage(),
    AddPage(),
    DroppedPage(),
    PlantoWatchPage()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Jiyu"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.arrow_upward,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.check,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.add,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.delete,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.note,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: tabs,
        ),
      ),
    );
  }
}
