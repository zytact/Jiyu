import 'package:flutter/material.dart';
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
          return Card(
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
                                  await deleteCompleted(data[index].name);
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
              color: Colors.blue);
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
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: refreshList,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
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
    );
  }
}
