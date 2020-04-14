import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'DroppedPage.dart';
import 'PlantoWatchPage.dart';
import 'WatchingPage.dart';
import 'database/completed.dart';

class CompletedPage extends StatefulWidget {
  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  var anime = getCompleted();

  Widget view(List<Completed> data) {
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
                    color: Colors.blue,
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
                                    await deleteCompleted(data[index].id);
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
      anime = getCompleted();
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
              enabled: true,
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
        title: Text("Completed"),
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
                  return Text("You have not completed anything",
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
