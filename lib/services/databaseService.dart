import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? db;

  Future open() async {
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, "main_db.db");
    // Directory(dbDirPath).create(recursive: true);
    print(" patth $dbDirPath");
    db = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
  create table Users (
    _id integer primary key autoincrement,
    admin integer not null,
    email text not null,
    password text not null
  )
''');
    });
  }

  Future addUser() async {
    var res = await db?.insert("Users", {"admin": 1, "email": "dsf", "password": "fjhdj"});
    return res;
  }
}
