import 'dart:convert';
import 'package:jiyu/sqlite-database/completed.dart';
import 'package:jiyu/sqlite-database/plantowatch.dart';
import 'package:jiyu/sqlite-database/dropped.dart';
import 'package:jiyu/sqlite-database/watching.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

void createJson() async {
  Map<String, dynamic> details = new Map<String, dynamic>();

  List<Watching> watching = await getWatching();
  List<Map<String, dynamic>> watchingMap = new List<Map<String, dynamic>>();
  for (var item in watching) {
    print(item);
    watchingMap.add(item.toMap());
  }
  details["Watching"] = watchingMap;

  List<Completed> completed = await getCompleted();
  List<Map<String, dynamic>> completedMap = new List<Map<String, dynamic>>();
  for (var item in completed) {
    completedMap.add(item.toMap());
  }
  details["Completed"] = completedMap;

  List<Dropped> dropped = await getDropped();
  List<Map<String, dynamic>> droppedMap = new List<Map<String, dynamic>>();
  for (var item in dropped) {
    droppedMap.add(item.toMap());
  }
  details["Dropped"] = droppedMap;

  List<Planned> planned = await getPlanned();
  List<Map<String, dynamic>> plannedMap = new List<Map<String, dynamic>>();
  for (var item in planned) {
    plannedMap.add(item.toMap());
  }
  details["Planned"] = plannedMap;
  String detailsToWrite = jsonEncode(details);
  String databasePath = await getDatabasesPath();
  final File file = File("$databasePath/details.json");
  if (file.existsSync()) {
    file.delete();
  }
  file.create();
  file.writeAsStringSync(detailsToWrite);
}
