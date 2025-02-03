import 'dart:io';

import 'package:menu_app/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  late Database db;

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
    var res = await db
        .insert("Users", {"admin": 1, "email": "admin", "password": "123"});
    return res;
  }

  Future<User?> findUser(String email) async {
    List<Map<String, dynamic>> maps =
        await db.query("Users", where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      print(maps);

      return User.fromMap(maps.first);
    }
    return null;
  }
}
