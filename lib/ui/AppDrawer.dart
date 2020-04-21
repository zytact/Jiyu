import 'package:flutter/material.dart';
import 'package:jiyu/auth/login.dart';
import 'package:jiyu/backup/download.dart';
import 'package:jiyu/ui/CompletedPage.dart';
import 'package:jiyu/ui/DroppedPage.dart';
import 'package:jiyu/ui/PlantoWatchPage.dart';
import 'package:jiyu/ui/WatchingPage.dart';

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
            color: this._routeToCompleted == false ? Colors.purple[900] : null,
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
                            builder: (BuildContext context) => DroppedPage()));
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
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 8.0,
            padding: EdgeInsets.all(0.0),
            color: Colors.purple,
            onPressed: () {
              download();
            },
            child: InkWell(
              child: Container(
                child: Text("Load from Backup"),
                constraints: BoxConstraints(maxHeight: 50.0, maxWidth: 140.0),
              ),
              splashColor: Colors.greenAccent,
            ),
          ),
          MaterialButton(
            onPressed: () async {
              AuthProvider().signOut();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 8.0,
            color: Colors.purple,
            padding: EdgeInsets.all(0.0),
            child: InkWell(
              child: Container(
                child: Text("Sign Out"),
                constraints: BoxConstraints(maxHeight: 50.0, maxWidth: 100.0),
              ),
              splashColor: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }
}
