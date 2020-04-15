import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  final backgroundColor = Color(0xFF33325F);
  var anime = getPlanned();

  Widget gridView(List<Planned> data) {
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
                          subtitle: Text(data[index].total_episodes.toString()),
                          isThreeLine: false,
                          onLongPress: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: backgroundColor,
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () async {
                                            await insertWatching(Watching(
                                                id: data[index].id,
                                                url: data[index].url,
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
                        )),
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
      anime = getPlanned();
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
      ),
      appBar: AppBar(
        backgroundColor: backgroundColor,
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
                  return gridView(snapshot.data);
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
        backgroundColor: Colors.purple,
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: backgroundColor,
                  title: Text("Add"),
                  content: AddPage(),
                );
              });
        },
        elevation: 8.0,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
