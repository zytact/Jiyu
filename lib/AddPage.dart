import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'database/completed.dart';
import 'database/dropped.dart';
import 'database/plantowatch.dart';
import 'database/watching.dart';
import 'package:http/http.dart' as http;


class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  
  List<String> _status = ["Watching", "Completed", "Dropped", "Plan to Watch"];
  var _currentItemSelected = "Watching";
  final animeName = TextEditingController();
  final watched_episodes = TextEditingController();
  bool _watchedEpisodeInput = true;
  final _formKey = GlobalKey<FormState>();

  Future<String> add() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Adding"),
          content: LinearProgressIndicator()
        );
      }
    );
    
    final String api = "https://api.jikan.moe/v3/search/anime?q=${animeName.text}&limit=100";
    var data;
    var response = await http.get(
      Uri.encodeFull(api),
      headers: {"Accept": "application/json"}
    );
    var convertToJson = json.decode(response.body);
    data = convertToJson["results"][0];
    print(data);
    switch (_currentItemSelected){
      case "Watching":{
        final anime = Watching(
          name: animeName.text,
          img: data['image_url'],
          total_episodes: data['episodes'],
          watched_episodes: int.parse(watched_episodes.text)
        );
        await insertWatching(anime);
      }
      break;

      case "Completed":{
        final anime = Completed(
          name: animeName.text,
          img: data['image_url'],
          total_episodes: data['episodes']
        );
        await insertCompleted(anime);
      }
      break;

      case "Dropped":{
        final anime = Dropped(
          name: animeName.text,
          img: data['image_url'],
          total_episodes: data['episodes'],
          watched_episodes: int.parse(watched_episodes.text)
        );
        await insertDropped(anime);
      }
      break;

      case "Plan to Watch":{
        final anime = Planned(
          name: animeName.text,
          img: data['image_url'],
          total_episodes: data['episodes']
        );
        await insertPlanned(anime);
      }
      break;
    }
    setState(() {
      animeName.text = "";
      watched_episodes.text = "";
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(child: Column(key: this._formKey, children: <Widget>[
          DropdownButton(
            items: this._status.map((String dropDownStringItem){
              return DropdownMenuItem(child: Text(dropDownStringItem), value: dropDownStringItem);}).toList(),
            onChanged: (String value){
              this.setState(() {
                this._currentItemSelected = value;
                if (this._currentItemSelected == "Plan to Watch" || this._currentItemSelected == "Completed"){
                  _watchedEpisodeInput = false;
                }else{
                  _watchedEpisodeInput = true;
                }
              });
            },
            value: this._currentItemSelected,
            ),
          TextFormField(
            autovalidate: true,
            autofocus: true,
            controller: animeName,
            decoration: InputDecoration(
              hintText: "Anime name"
            ),
            validator: (value){
              if (value.isEmpty){
                return "You have to enter anime name";
              }
            },
          ),
          TextFormField(
            autovalidate: true,
            enabled: _watchedEpisodeInput,
            controller: watched_episodes,
            decoration: InputDecoration(
              hintText: "Watched Episodes"
            ),
            validator: (value){
              if (value.isEmpty){
                return "Please enter how many episodes you've watched";
              }
              try{
                int.parse(watched_episodes.text);
              }
              catch(e){
                watched_episodes.clear();
                return "Watched episode should be a number (whole number";
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FloatingActionButton.extended(
              onPressed: add, 
              label: Text("Add")
              ),
          )
        ],)),
      ),
      
    );
  }

}