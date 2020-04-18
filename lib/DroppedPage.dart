import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'AppDrawer.dart';
import 'AddPage.dart';
import 'database/watching.dart';
import 'database/dropped.dart';

class DroppedPage extends StatefulWidget {
  @override
  _DroppedPageState createState() => _DroppedPageState();
}

class _DroppedPageState extends State<DroppedPage> {
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  final backgroundColor = Color(0xFF33325F);
  var anime = getDropped();

  Widget gridView(List<Dropped> data) {
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
                          subtitle: Text(
                              data[index].watched_episodes.toString() +
                                  "/" +
                                  data[index].total_episodes.toString()),
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
                                                watched_episodes: data[index]
                                                    .watched_episodes));
                                            await deleteDropped(data[index].id);
                                            Navigator.of(context).pop();
                                            refreshList();
                                          },
                                          child: Text("Add to Watching")),
                                      FlatButton(
                                          onPressed: () async {
                                            await deleteDropped(data[index].id);
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
      anime = getDropped();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: AppDrawer(true, true, false, true),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Dropped"),
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
                  return Text("You have not dropped anything",
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
