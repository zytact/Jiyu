import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Completed {
  final String name;
  final String img;
  final String url;
  final int total_episodes;
  final int id;

  Completed({this.url, this.name, this.img, this.total_episodes, this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'img': img,
      'total_episodes': total_episodes
    };
  }
}

final Future<Database> database = openDatabase(
  join(getDatabasesPath().toString(), 'completed.db'),
  onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE Completed(id INT PRIMARY KEY, name TEXT, img TEXT, total_episodes INT, url TEXT)",
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
    where: "id = ?",
    whereArgs: [completed.id],
  );
}

Future<void> deleteCompleted(int id) async {
  final db = await database;

  await db.delete(
    'Completed',
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<List<Completed>> getCompleted() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Completed');

  return List.generate(maps.length, (i) {
    return Completed(
        name: maps[i]['name'],
        url: maps[i]['url'],
        img: maps[i]['img'],
        total_episodes: maps[i]['total_episodes'],
        id: maps[i]['id']);
  }).toList();
}
