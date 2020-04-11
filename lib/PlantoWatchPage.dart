import 'package:flutter/material.dart';
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
                  onTap: () {
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
    return RefreshIndicator(
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
    );
  }
}
