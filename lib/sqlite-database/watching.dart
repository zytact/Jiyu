import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Watching {
  final int id;
  final String name;
  final String img;
  final String url;
  final int total_episodes;
  final int watched_episodes;

  Watching(
      {this.id,
      this.name,
      this.url,
      this.img,
      this.total_episodes,
      this.watched_episodes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
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
      "CREATE TABLE Watching(id INT PRIMARY KEY, name TEXT, img TEXT, total_episodes INT, watched_episodes INT, url TEXT)",
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
    where: "id = ?",
    whereArgs: [watching.id],
  );
}

Future<void> deleteWatching(int id) async {
  final db = await database;

  await db.delete(
    'Watching',
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<List<Watching>> getWatching() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Watching');

  return List.generate(maps.length, (i) {
    return Watching(
        id: maps[i]['id'],
        name: maps[i]['name'],
        url: maps[i]['url'],
        img: maps[i]['img'],
        total_episodes: maps[i]['total_episodes'],
        watched_episodes: maps[i]['watched_episodes']);
  }).toList();
}
