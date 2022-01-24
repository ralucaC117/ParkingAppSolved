import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_app_client/space.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE Spaces(id INTEGER PRIMARY KEY, number TEXT, address TEXT, status TEXT, count INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<List<Space>> retrieveSpaces() async {
    Database database = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await database.query('Spaces');
    var r = queryResult.map((e) => Space.fromMap(e)).toList();
    return queryResult.map((e) => Space.fromMap(e)).toList();
  }

  Future<int> insertSpace(Space task) async {
    List<Space> spaces = await retrieveSpaces();
    print('in db');
    spaces.forEach((element) {
      print(element.toString());
    });
    final Database db = await initializeDB();
    final result = await db.insert('Spaces', task.toMap());
    print(result);
    return result;
  }

  Future<void> deleteSpace(int? id) async {
    final db = await initializeDB();
    await db.delete(
      'Spaces',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateTask(Space space) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.update(
      "Spaces",
      space.toMap(),
      where: "id = ?",
      whereArgs: [space.id],
    );
    return result;
  }
}
