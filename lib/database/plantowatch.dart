import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Planned {
  final int id;
  final String url;
  final String name;
  final String img;
  final int total_episodes;

  Planned({this.url, this.id, this.name, this.img, this.total_episodes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'img': img,
      'total_episodes': total_episodes,
    };
  }
}

final Future<Database> database = openDatabase(
  join(getDatabasesPath().toString(), 'planned.db'),
  onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE Planned(id INT PRIMARY KEY, name TEXT, img TEXT, total_episodes INT, url TEXT)",
    );
  },
  version: 1,
);

Future<void> insertPlanned(Planned planned) async {
  final Database db = await database;
  await db.insert(
    'Planned',
    planned.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updatePlanned(Planned planned) async {
  final db = await database;

  await db.update(
    'Planned',
    planned.toMap(),
    where: "id = ?",
    whereArgs: [planned.id],
  );
}

Future<void> deletePlanned(int id) async {
  final db = await database;

  await db.delete(
    'Planned',
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

Future<List<Planned>> getPlanned() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Planned');

  return List.generate(maps.length, (i) {
    return Planned(
        id: maps[i]['id'],
        name: maps[i]['name'],
        url: maps[i]['url'],
        img: maps[i]['img'],
        total_episodes: maps[i]['total_episodes']);
  });
}
