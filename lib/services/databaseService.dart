import 'dart:io';

import 'package:menu_app/models/meal_model.dart';
import 'package:menu_app/models/order_model.dart';
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
      await db.execute('''
  create table Meals (
    _id integer primary key autoincrement,
    title text not null,
    description text not null,
    image text not null,
    sunday integer not null,
    monday integer not null,
    tuesday integer not null,
    wednesday integer not null,
    thursday integer not null,
    friday integer not null,
    saturday integer not null,
   
  )
''');
      await db.execute('''
  create table Orders (
    _id integer primary key autoincrement,
    meal integer not null,
    user integer not null,
    date text not null,
    FOREIGN KEY (meal) REFERENCES Meals (_id),
    FOREIGN KEY (user) REFERENCES Users (_id)
  )
''');
      await db
          .insert("Users", {"admin": 0, "email": "guest", "password": "123"});
      await db
          .insert("Users", {"admin": 1, "email": "admin", "password": "123"});
    });
  }

  Future addUser() async {
    var res = await db
        .insert("Users", {"admin": 0, "email": "guest", "password": "123"});
    return res;
  }

  Future<User?> findUser(String email) async {
    List<Map<String, Object?>> maps =
        await db.query("Users", where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future addMeal(Meal meal) async {
    var res = await db.insert("Meals", meal.toMap());
    return res;
  }

  Future<List<Meal>> getMeals() async {
    List<Map<String, Object?>> records = await db.query('Meals');
    List<Meal> res = [];
    for (var m in records) {
      res.add(Meal.fromMap(m));
    }
    return res;
  }

  Future updateMeal(Meal meal) async {
    return await db
        .update("Meals", meal.toMap(), where: '_id = ?', whereArgs: [meal.id]);
  }

  Future<int> deleteMeal(Meal meal) async {
    return await db.delete("Meals", where: '_id = ?', whereArgs: [meal.id]);
  }

  Future addOrder(Order order) async {
    var res = await db.insert("Orders", order.toMap());
    return res;
  }

  Future<Order?> getTodayOrder(int user, String date) async {
    List<Map<String, Object?>> maps = await db.query("Orders",
        where: 'date = ? and user = ?', whereArgs: [date, user]);
    if (maps.isNotEmpty) {
      print(maps.first);
      return Order.fromMap(maps.first);
    }
    return null;
  }
}
