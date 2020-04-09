import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Planned {
  final String name;
  final String img;
  final int total_episodes;

  Planned({this.name, this.img, this.total_episodes});
  Map<String, dynamic> toMap() {
    return {
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
      "CREATE TABLE Planned(name TEXT PRIMARY KEY, img TEXT, total_episodes INT)",
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
    where: "name = ?",
    whereArgs: [planned.name],
  );
}

Future<void> deletePlanned(String name) async {
  final db = await database;

  await db.delete(
    'Planned',
    where: "name = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [name],
  );
}

Future<List<Planned>> getPlanned() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Planned');

  return List.generate(maps.length, (i) {
    return Planned(
        name: maps[i]['name'],
        img: maps[i]['img'],
        total_episodes: maps[i]['total_episodes']);
  });
}
