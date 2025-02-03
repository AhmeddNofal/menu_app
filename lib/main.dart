import 'package:flutter/material.dart';
import 'package:menu_app/services/databaseService.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService dbService = DatabaseService();
  Database? db;

  void initDB() async {
    await dbService.open();
    db = dbService.db;
  //   await db?.execute('''
  // create table Users (
  //   _id integer primary key autoincrement,
  //   admin integer not null,
  //   email text not null,
  //   password text not null
  // )    ''');
    await dbService.addUser();
    print("initState Called");
  }



  @override
  initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) =>  initDB());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("home")),
    );
  }
}
