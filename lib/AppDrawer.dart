import 'package:flutter/material.dart';

import 'CompletedPage.dart';
import 'DroppedPage.dart';
import 'PlantoWatchPage.dart';
import 'WatchingPage.dart';

class AppDrawer extends StatelessWidget {
  final bool _routeToWatching;
  final bool _routeToCompleted;
  final bool _routeToDropped;
  final bool _routeToPlanned;
  AppDrawer(this._routeToWatching, this._routeToCompleted, this._routeToDropped,
      this._routeToPlanned);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.purple[700], Colors.purple[900]],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/icon.png",
                    width: 150.0,
                  ),
                  Text(
                    "Jiyu",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Made by Arnab",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SelectableText(
                    "(https://github.com/Arnab771)",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Container(
              color: this._routeToWatching == false ? Colors.purple[900] : null,
              child: ListTile(
                leading: Icon(Icons.arrow_upward),
                title: Text("Watching"),
                onTap: () {
                  if (this._routeToWatching) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => WatchingPage()));
                  }
                },
              ),
            ),
            Container(
              color:
                  this._routeToCompleted == false ? Colors.purple[900] : null,
              child: ListTile(
                  leading: Icon(Icons.check),
                  title: Text("Completed"),
                  onTap: () {
                    if (this._routeToCompleted) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CompletedPage()));
                    }
                  }),
            ),
            Container(
              color: this._routeToDropped == false ? Colors.purple[900] : null,
              child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Dropped"),
                  onTap: () {
                    if (this._routeToDropped) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DroppedPage()));
                    }
                  }),
            ),
            Container(
              color: this._routeToPlanned == false ? Colors.purple[900] : null,
              child: ListTile(
                  leading: Icon(Icons.note),
                  title: Text("Plan to Watch"),
                  onTap: () {
                    if (this._routeToPlanned) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PlantoWatchPage()));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
