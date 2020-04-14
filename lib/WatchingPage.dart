import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jiyu/AddPage.dart';
import 'CompletedPage.dart';
import 'DroppedPage.dart';
import 'PlantoWatchPage.dart';
import 'database/watching.dart';
import 'database/completed.dart';
import 'database/dropped.dart';

class WatchingPage extends StatefulWidget {
  @override
  _WatchingPageState createState() => _WatchingPageState();
}

class _WatchingPageState extends State<WatchingPage> {
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  var anime = getWatching();

  Widget view(List<Watching> data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: (data != null) ? data.length : 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(14)),
              child: Card(
                child: ListTile(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () async {
                                      await insertCompleted(Completed(
                                          name: data[index].name,
                                          img: data[index].img,
                                          total_episodes:
                                              data[index].total_episodes));
                                      await deleteWatching(data[index].id);
                                      Navigator.of(context).pop();
                                      refreshList();
                                    },
                                    child: Text("Add to Completed")),
                                FlatButton(
                                    onPressed: () async {
                                      await insertDropped(Dropped(
                                          name: data[index].name,
                                          img: data[index].img,
                                          total_episodes:
                                              data[index].total_episodes,
                                          watched_episodes:
                                              data[index].watched_episodes));
                                      await deleteWatching(data[index].id);
                                      Navigator.of(context).pop();
                                      refreshList();
                                    },
                                    child: Text("Add to Dropped")),
                                FlatButton(
                                    onPressed: () async {
                                      await deleteWatching(data[index].id);
                                      Navigator.of(context).pop();
                                      refreshList();
                                    },
                                    child: Text("Delete"))
                              ],
                            );
                          });
                    },
                    leading: Image.network(data[index].img),
                    title: Text(data[index].name),
                    subtitle: Text(data[index].watched_episodes.toString() +
                        "/" +
                        data[index].total_episodes.toString()),
                    isThreeLine: true,
                    trailing: FlatButton(
                        onPressed: () {
                          if (data[index].total_episodes !=
                              data[index].watched_episodes) {
                            updateWatching(Watching(
                                id: data[index].id,
                                name: data[index].name,
                                img: data[index].img,
                                watched_episodes:
                                    data[index].watched_episodes + 1,
                                total_episodes: data[index].total_episodes));
                            refreshList();
                          }
                        },
                        child: Icon(Icons.add_circle))),
              ),
            ),
          );
        });
  }

  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshList() async {
    _refreshKey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      anime = getWatching();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icon.png",
                      width: 150.0,
                    ),
                  ),
                  Text(
                    "Jiyu",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text("Watching"),
              enabled: true,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.check),
              title: Text("Completed"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CompletedPage())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Dropped"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DroppedPage())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.note),
              title: Text("Plan to Watch"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PlantoWatchPage())),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Watching"),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: refreshList,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: anime,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return view(snapshot.data);
                }
                if (snapshot.data == null || snapshot.data.length) {
                  return Text("You are not watching anything",
                      style: TextStyle(fontSize: 20.0, color: Colors.grey));
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Add"),
                  content: AddPage(),
                );
              });
        },
        elevation: 6.0,
        child: Icon(Icons.add),
      ),
    );
  }
}
