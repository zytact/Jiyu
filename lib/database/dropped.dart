import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Dropped{
  final String name;
  final String img;
  final int total_episodes;
  final int watched_episodes;

  Dropped({this.name, this.img, this.total_episodes, this.watched_episodes});
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'img': img,
      'total_episodes': total_episodes,
      'watched_episodes': watched_episodes
    };
  }
}

final Future<Database> database = openDatabase(
  join(getDatabasesPath().toString(), 'dropped.db'),
  onCreate: (db, version){
    return db.execute(
      "CREATE TABLE Dropped(name TEXT PRIMARY KEY, img TEXT, total_episodes INT, watched_episodes INT)",
    );
  },
  version: 1,
  );

  Future<void> insertDropped(Dropped dropped) async {
 
  final Database db = await database;
  await db.insert(
    'Dropped',
    dropped.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  }

  Future<void> updateDropped(Dropped dropped) async {
  
  final db = await database;

  
  await db.update(
    'Dropped',
    dropped.toMap(),
    where: "name = ?",
    whereArgs: [dropped.name],
  );
}

Future<void> deleteDropped(String name) async {
  final db = await database;

  await db.delete(
    'Dropped',
    where: "name = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [name],
  );
}

Future<List<Dropped>> getDropped() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Dropped');

  return List.generate(maps.length, (i) {
    return Dropped(
      name: maps[i]['name'],
      img: maps[i]['img'],
      total_episodes: maps[i]['total_episodes'],
      watched_episodes: maps[i]['watched_episodes']
    );
  });
}