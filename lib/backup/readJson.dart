import 'dart:convert';
import 'package:jiyu/sqlite-database/completed.dart';
import 'package:jiyu/sqlite-database/plantowatch.dart';
import 'package:jiyu/sqlite-database/dropped.dart';
import 'package:jiyu/sqlite-database/watching.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

void readJson() async {
  String databasePath = await getDatabasesPath();
  final File file = File("$databasePath/details.json");
  var details = jsonDecode(file.readAsStringSync());

  var watching = details["Watching"];
  for (int i = 0; i < watching.length; i++) {
    var decodedWatching = watching[i];
    Watching watchingToInsert = Watching(
        id: decodedWatching['id'],
        name: decodedWatching['name'],
        url: decodedWatching['url'],
        img: decodedWatching['img'],
        total_episodes: decodedWatching['total_episodes'],
        watched_episodes: decodedWatching['watched_episodes']);
    insertWatching(watchingToInsert);
  }

  var completed = details["Completed"];
  for (int i = 0; i < completed.length; i++) {
    var decodedCompleted = completed[i];
    Completed completedToInsert = Completed(
        name: decodedCompleted['name'],
        url: decodedCompleted['url'],
        img: decodedCompleted['img'],
        total_episodes: decodedCompleted['total_episodes'],
        id: decodedCompleted['id']);
    insertCompleted(completedToInsert);
  }

  var dropped = details["Dropped"];
  for (int i = 0; i < dropped.length; i++) {
    var decodedDropped = dropped[i];
    Dropped droppedToInsert = Dropped(
        id: decodedDropped['id'],
        name: decodedDropped['name'],
        url: decodedDropped['url'],
        img: decodedDropped['img'],
        total_episodes: decodedDropped['total_episodes'],
        watched_episodes: decodedDropped['watched_episodes']);
    insertDropped(droppedToInsert);
  }

  var planned = details["Planned"];
  for (int i = 0; i < planned.length; i++) {
    var decodedPlanned = planned[i];
    Planned plannedToInsert = Planned(
        id: decodedPlanned['id'],
        name: decodedPlanned['name'],
        url: decodedPlanned['url'],
        img: decodedPlanned['img'],
        total_episodes: decodedPlanned['total_episodes']);
    insertPlanned(plannedToInsert);
  }
}
