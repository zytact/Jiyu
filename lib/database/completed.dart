import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Completed{
  final String name;
  final String img;
  final int total_episodes;

  Completed({this.name, this.img, this.total_episodes});
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'img': img,
      'total_episodes': total_episodes
    };
  }
}

final Future<Database> database = openDatabase(
  join(getDatabasesPath().toString(), 'completed.db'),
  onCreate: (db, version){
    return db.execute(
      "CREATE TABLE Completed(name TEXT PRIMARY KEY, img TEXT, total_episodes INT)",
    );
  },
  version: 1,
  );

  Future<void> insertCompleted(Completed completed) async {
 
  final Database db = await database;
  await db.insert(
    'Completed',
    completed.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  }

  Future<void> updateCompleted(Completed completed) async {
  
  final db = await database;

  
  await db.update(
    'Completed',
    completed.toMap(),
    where: "name = ?",
    whereArgs: [completed.name],
  );
}

Future<void> deleteCompleted(String name) async {
  final db = await database;

  await db.delete(
    'Completed',
    where: "name = ?",
    whereArgs: [name],
  );
}

Future<List<Completed>> getCompleted() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Completed');

  return List.generate(maps.length, (i) {
    return Completed(
      name: maps[i]['name'],
      img: maps[i]['img'],
      total_episodes: maps[i]['total_episodes']
    );
  }).toList();
}