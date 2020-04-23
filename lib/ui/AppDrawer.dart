import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:jiyu/auth/login.dart';
import 'package:jiyu/backup/download.dart';
import 'package:jiyu/sqlite-database/completed.dart';
import 'package:jiyu/sqlite-database/dropped.dart';
import 'package:jiyu/sqlite-database/watching.dart';
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

  Future<String> totalWatchTime() async {
    String _totalWatchTimeHour;
    int _totalWatchTimeMin = 0;
    List<Watching> watching = await getWatching();
    for (Watching item in watching) {
      _totalWatchTimeMin += item.watched_episodes;
    }

    List<Completed> completed = await getCompleted();
    for (Completed item in completed) {
      _totalWatchTimeMin += item.total_episodes;
    }

    List<Dropped> dropped = await getDropped();
    for (Dropped item in dropped) {
      _totalWatchTimeMin += item.watched_episodes;
    }
    _totalWatchTimeHour = ((_totalWatchTimeMin / 60) / 24).toStringAsFixed(2);

    return _totalWatchTimeHour;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey[900],
            child: Column(
              children: <Widget>[
                FutureBuilder(
                    future: AuthProvider().getCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return UserAccountsDrawerHeader(
                          accountName: Text(snapshot.data.displayName),
                          accountEmail: Text(snapshot.data.email),
                          currentAccountPicture: CircleAvatar(
                            child: Image.network(snapshot.data.photoUrl),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                    }),
                FutureBuilder(
                  future: totalWatchTime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListTile(
                        title: Text(
                          "Watch time: ${snapshot.data} days",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            color: this._routeToWatching == false ? Colors.black12 : null,
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
            color: this._routeToCompleted == false ? Colors.black12 : null,
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
            color: this._routeToDropped == false ? Colors.black12 : null,
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
            color: this._routeToPlanned == false ? Colors.black12 : null,
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
            color: Colors.blueAccent,
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
            color: Colors.blueAccent,
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
