import 'package:flutter/material.dart';
import 'database/watching.dart';
import 'database/completed.dart';
import 'database/dropped.dart';

class WatchingPage extends StatefulWidget {
  @override
  _WatchingPageState createState() => _WatchingPageState();
}

class _WatchingPageState extends State<WatchingPage> {

  @override
  void initState(){
    super.initState();
    refreshList();
  }
  var anime = getWatching();

  Widget view(List<Watching> data){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: (data != null) ? data.length : 0,
        itemBuilder: (context, index){
          return Card(
              child: ListTile(
                onLongPress: (){
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context){
                      return AlertDialog(
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () async{
                              await insertCompleted(Completed(name: data[index].name, img: data[index].img, total_episodes: data[index].total_episodes));
                              await deleteWatching(data[index].name);
                              Navigator.of(context).pop();
                              refreshList();
                            }, 
                            child: Text("Add to Completed")
                            ),
                          FlatButton(
                            onPressed: () async{
                              await insertDropped(Dropped(name: data[index].name, img: data[index].img, total_episodes: data[index].total_episodes, watched_episodes: data[index].watched_episodes));
                              await deleteWatching(data[index].name);
                              Navigator.of(context).pop();
                              refreshList();
                            }, 
                            child: Text("Add to Dropped")
                            ),
                        ],
                      );
                    }
                  );
                },
                leading: Image.network(data[index].img),
                title: Text(data[index].name),
                subtitle: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Text(data[index].watched_episodes.toString() + "/" + data[index].total_episodes.toString()),
                        FlatButton(
                        onPressed: (){
                          if (data[index].total_episodes != data[index].watched_episodes){
                            updateWatching(Watching(
                            name: data[index].name,
                            img: data[index].img,
                            watched_episodes: data[index].watched_episodes + 1,
                            total_episodes: data[index].total_episodes
                          ));
                          refreshList();
                          }
                        }, 
                        child: Icon(Icons.add_circle)
                        )
                      ],
                    )
                  ],
                ),
                trailing: FlatButton(
                  onPressed: () async{
                    await deleteWatching(data[index].name);
                    refreshList();
                  }, 
                  child: Icon(Icons.delete))),
                color: Colors.green
              );
        }
      )
    );
          
  }
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshList() async{
    _refreshKey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      anime = getWatching();
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
            builder: (context, snapshot){
              if (snapshot.hasData){
                return view(snapshot.data);
              }
              if (snapshot.data == null || snapshot.data.length){
                return Text("You are not watching anything", style: TextStyle(fontSize: 20.0, color: Colors.grey));
              }
            },
            ),
        ),
      ),
    );
  }
}
