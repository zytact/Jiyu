import 'package:flutter/material.dart';
import 'database/watching.dart';
import 'database/dropped.dart';

class DroppedPage extends StatefulWidget {
  @override
  _DroppedPageState createState() => _DroppedPageState();
}

class _DroppedPageState extends State<DroppedPage> {

  @override
  void initState(){
    super.initState();
    refreshList();
  }
  var anime = getDropped();

  Widget view(List<Dropped> data){
    return ListView.builder(
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
                            await insertWatching(Watching(name: data[index].name, img: data[index].img, total_episodes: data[index].total_episodes, watched_episodes: data[index].watched_episodes));
                            await deleteDropped(data[index].name);
                            Navigator.of(context).pop();
                            refreshList();
                          }, 
                          child: Text("Add to Watching")
                          ),
                        FlatButton(
                          onPressed: () async{
                            await deleteDropped(data[index].name);
                            Navigator.of(context).pop();
                            refreshList();
                          }, 
                          child: Text("Delete")
                          )
                      ],
                    );
                  }
                );
              },
              leading: Image.network(data[index].img),
              title: Text(data[index].name),
              subtitle: Text(data[index].watched_episodes.toString() + "/" + data[index].total_episodes.toString()),
              ),
              color: Colors.red
            );
      }
    );
          
  }
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshList() async{
    _refreshKey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      anime = getDropped();
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
                return Text("You have not dropped anything", style: TextStyle(fontSize: 20.0, color: Colors.grey));
              }
            },
            ),
        ),
      ),
    );
  }
}
