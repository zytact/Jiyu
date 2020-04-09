import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Watching {
  final String name;
  final String img;
  final int total_episodes;
  final int watched_episodes;

  Watching({this.name, this.img, this.total_episodes, this.watched_episodes});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'img': img,
      'total_episodes': total_episodes,
      'watched_episodes': watched_episodes
    };
  }
}

final Future<Database> database = openDatabase(
  join(getDatabasesPath().toString(), 'watching.db'),
  onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE Watching(name TEXT PRIMARY KEY, img TEXT, total_episodes INT, watched_episodes INT)",
    );
  },
  version: 1,
);

Future<void> insertWatching(Watching watching) async {
  final Database db = await database;
  await db.insert(
    'Watching',
    watching.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateWatching(Watching watching) async {
  final db = await database;

  await db.update(
    'Watching',
    watching.toMap(),
    where: "name = ?",
    whereArgs: [watching.name],
  );
}

Future<void> deleteWatching(String name) async {
  final db = await database;

  await db.delete(
    'Watching',
    where: "name = ?",
    whereArgs: [name],
  );
}

Future<List<Watching>> getWatching() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Watching');

  return List.generate(maps.length, (i) {
    return Watching(
        name: maps[i]['name'],
        img: maps[i]['img'],
        total_episodes: maps[i]['total_episodes'],
        watched_episodes: maps[i]['watched_episodes']);
  }).toList();
}
