import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jiyu/backup/upload.dart';
import 'package:jiyu/sqlite-database/completed.dart';
import 'package:jiyu/sqlite-database/dropped.dart';
import 'package:jiyu/sqlite-database/plantowatch.dart';
import 'package:jiyu/sqlite-database/watching.dart';
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
  final backgroundColor = Color(0xFF33325F);

  Future<String> add() async {
    if (animeName.text == "") {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              title: Text("Error"),
              content: Text("Please fill in the required fields"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                )
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              title: Text("Adding"),
              content: LinearProgressIndicator(),
            );
          });

      final String _api =
          "https://api.jikan.moe/v3/search/anime?q=${animeName.text}&limit=100";
      var _data;
      var response = await http
          .get(Uri.encodeFull(_api), headers: {"Accept": "application/json"});
      var convertToJson = json.decode(response.body);
      _data = convertToJson["results"][0];
      switch (_currentItemSelected) {
        case "Watching":
          {
            if (watched_episodes.text == "") {
              final anime = Watching(
                  id: _data['mal_id'],
                  url: _data['url'],
                  name: animeName.text,
                  img: _data['image_url'],
                  total_episodes: _data['episodes'],
                  watched_episodes: 0);
              await insertWatching(anime);
            } else {
              final anime = Watching(
                  id: _data['mal_id'],
                  url: _data['url'],
                  name: animeName.text,
                  img: _data['image_url'],
                  total_episodes: _data['episodes'],
                  watched_episodes: int.parse(watched_episodes.text));
              await insertWatching(anime);
            }
          }
          break;

        case "Completed":
          {
            final anime = Completed(
                id: _data['mal_id'],
                url: _data['url'],
                name: animeName.text,
                img: _data['image_url'],
                total_episodes: _data['episodes']);
            await insertCompleted(anime);
          }
          break;

        case "Dropped":
          {
            if (watched_episodes.text == "") {
              final anime = Dropped(
                  id: _data['mal_id'],
                  url: _data['url'],
                  name: animeName.text,
                  img: _data['image_url'],
                  total_episodes: _data['episodes'],
                  watched_episodes: 0);
              await insertDropped(anime);
            } else {
              final anime = Dropped(
                  id: _data['mal_id'],
                  url: _data['url'],
                  name: animeName.text,
                  img: _data['image_url'],
                  total_episodes: _data['episodes'],
                  watched_episodes: int.parse(watched_episodes.text));
              await insertDropped(anime);
            }
          }
          break;

        case "Plan to Watch":
          {
            final anime = Planned(
                id: _data['mal_id'],
                url: _data['url'],
                name: animeName.text,
                img: _data['image_url'],
                total_episodes: _data['episodes']);
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
    upload();

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          child: Column(
        key: this._formKey,
        children: <Widget>[
          DropdownButton(
            items: this._status.map((String dropDownStringItem) {
              return DropdownMenuItem(
                  child: Text(dropDownStringItem), value: dropDownStringItem);
            }).toList(),
            onChanged: (String value) {
              this.setState(() {
                this._currentItemSelected = value;
                if (this._currentItemSelected == "Plan to Watch" ||
                    this._currentItemSelected == "Completed") {
                  _watchedEpisodeInput = false;
                } else {
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
            decoration: InputDecoration(hintText: "Anime name"),
            validator: (value) {
              if (value.isEmpty) {
                return "You have to enter anime name";
              }
            },
          ),
          TextFormField(
            autovalidate: true,
            keyboardType: TextInputType.number,
            enabled: _watchedEpisodeInput,
            controller: watched_episodes,
            decoration: InputDecoration(hintText: "Watched Episodes"),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter how many episodes you've watched";
              }
              try {
                int.parse(watched_episodes.text);
              } catch (e) {
                watched_episodes.clear();
                return "Watched episode should be a number (whole number";
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FloatingActionButton.extended(
              elevation: 8.0,
              onPressed: add,
              backgroundColor: Colors.purple,
              label: Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
