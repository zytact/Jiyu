import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'CompletedPage.dart';
import 'DroppedPage.dart';
import 'WatchingPage.dart';
import 'database/plantowatch.dart';
import 'database/watching.dart';

class PlantoWatchPage extends StatefulWidget {
  @override
  _PlantoWatchPageState createState() => _PlantoWatchPageState();
}

class _PlantoWatchPageState extends State<PlantoWatchPage> {
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  var anime = getPlanned();

  Widget view(List<Planned> data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: (data != null) ? data.length : 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
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
                                    await insertWatching(Watching(
                                        name: data[index].name,
                                        img: data[index].img,
                                        total_episodes:
                                            data[index].total_episodes,
                                        watched_episodes: 0));
                                    await deletePlanned(data[index].id);
                                    Navigator.of(context).pop();
                                    refreshList();
                                  },
                                  child: Text("Add to Watching")),
                              FlatButton(
                                  onPressed: () async {
                                    await deletePlanned(data[index].id);
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
                  subtitle: Text(data[index].total_episodes.toString()),
                ),
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
      anime = getPlanned();
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
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WatchingPage())),
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
              enabled: true,
              title: Text("Plan to Watch"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Plan to Watch"),
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
                  return Text("Nothing here",
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
