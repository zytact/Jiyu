import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'AddPage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  final backgroundColor = Color(0xFF33325F);
  var anime = getWatching();

  Widget gridView(List<Watching> data) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: (data != null) ? data.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            padding: EdgeInsets.all(5.0),
            child: Card(
              child: Hero(
                tag: data[index].name,
                child: Material(
                    child: InkWell(
                  child: GridTile(
                    footer: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [Colors.purple, Colors.blue[500]],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                        child: ListTile(
                            title: Text(
                              data[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: ClipOval(
                              child: Material(
                                child: InkWell(
                                  child: Icon(Icons.add_circle),
                                  splashColor: Colors.greenAccent,
                                  onTap: () {
                                    if (data[index].total_episodes !=
                                        data[index].watched_episodes) {
                                      updateWatching(Watching(
                                          id: data[index].id,
                                          name: data[index].name,
                                          img: data[index].img,
                                          watched_episodes:
                                              data[index].watched_episodes + 1,
                                          total_episodes:
                                              data[index].total_episodes));
                                      refreshList();
                                    }
                                  },
                                ),
                              ),
                            ),
                            subtitle: Text(
                                data[index].watched_episodes.toString() +
                                    "/" +
                                    data[index].total_episodes.toString()),
                            isThreeLine: false,
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: backgroundColor,
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () async {
                                              await insertCompleted(Completed(
                                                  id: data[index].id,
                                                  url: data[index].url,
                                                  name: data[index].name,
                                                  img: data[index].img,
                                                  total_episodes: data[index]
                                                      .total_episodes));
                                              await deleteWatching(
                                                  data[index].id);
                                              Navigator.of(context).pop();
                                              refreshList();
                                            },
                                            child: Text("Add to Completed")),
                                        FlatButton(
                                            onPressed: () async {
                                              await insertDropped(Dropped(
                                                  id: data[index].id,
                                                  url: data[index].url,
                                                  name: data[index].name,
                                                  img: data[index].img,
                                                  total_episodes: data[index]
                                                      .total_episodes,
                                                  watched_episodes: data[index]
                                                      .watched_episodes));
                                              await deleteWatching(
                                                  data[index].id);
                                              Navigator.of(context).pop();
                                              refreshList();
                                            },
                                            child: Text("Add to Dropped")),
                                        FlatButton(
                                            onPressed: () async {
                                              await deleteWatching(
                                                  data[index].id);
                                              Navigator.of(context).pop();
                                              refreshList();
                                            },
                                            child: Text("Delete"))
                                      ],
                                    );
                                  });
                            })),
                    child: Image.network(
                      data[index].img,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
              ),
            ));
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 2),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
    );
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
      backgroundColor: backgroundColor,
      drawer: Drawer(
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
      ),
      appBar: AppBar(
        title: Text("Watching"),
        backgroundColor: backgroundColor,
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
                  return gridView(snapshot.data);
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
                  backgroundColor: backgroundColor,
                  content: AddPage(),
                );
              });
        },
        backgroundColor: Colors.purple,
        elevation: 8.0,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
