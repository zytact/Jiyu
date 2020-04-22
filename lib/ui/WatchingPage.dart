import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jiyu/backup/upload.dart';
import 'package:jiyu/ui/AppDrawer.dart';
import 'package:jiyu/ui/AddPage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jiyu/sqlite-database/watching.dart';
import 'package:jiyu/sqlite-database/completed.dart';
import 'package:jiyu/sqlite-database/dropped.dart';

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
                    footer: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [Colors.blue[800], Colors.blue[500]],
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
                                                data[index].watched_episodes +
                                                    1,
                                            total_episodes:
                                                data[index].total_episodes));
                                        refreshList();
                                        upload();
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
                                        backgroundColor: Colors.grey[900],
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
                                                upload();
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
                                                    watched_episodes:
                                                        data[index]
                                                            .watched_episodes));
                                                await deleteWatching(
                                                    data[index].id);
                                                Navigator.of(context).pop();
                                                refreshList();
                                                upload();
                                              },
                                              child: Text("Add to Dropped")),
                                          FlatButton(
                                              onPressed: () async {
                                                await deleteWatching(
                                                    data[index].id);
                                                Navigator.of(context).pop();
                                                refreshList();
                                                upload();
                                              },
                                              child: Text("Delete"))
                                        ],
                                      );
                                    });
                              })),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        data[index].img,
                        fit: BoxFit.cover,
                      ),
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
      // backgroundColor: backgroundColor,
      drawer: AppDrawer(false, true, true, true),
      appBar: AppBar(
        title: Text("Watching"),
        // backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.grey[900],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Add"),
                  backgroundColor: Colors.grey[900],
                  content: AddPage(),
                );
              });
        },
        backgroundColor: Colors.blueAccent,
        elevation: 8.0,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
