import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/cubits/dbService_cubit.dart';
import 'package:menu_app/cubits/user_cubit.dart';
import 'package:menu_app/models/user_model.dart';
import 'package:menu_app/pages/admin_page.dart';
import 'package:menu_app/pages/user_page.dart';
import 'package:menu_app/services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final DatabaseService dbService = DatabaseService();
  Database? db;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? emailVal;
  String? passwordVal;
  bool errorMsg = false;

  Future initDB() async {
    await dbService.open();
    db = dbService.db;
//     await db?.execute('''
//   create table Orders (
//     _id integer primary key autoincrement,
//     meal integer not null,
//     user integer not null,
//     date text not null,
//     FOREIGN KEY (meal) REFERENCES Meals (_id),
//     FOREIGN KEY (user) REFERENCES Users (_id)
//   )
// ''');
    // await dbService.addUser();
    // User? res = await dbService.findUser("admin");
    context.read<DbserviceCubit>().update(dbService);

    print("initState Called");
    // context
    //     .read<UserCubit>()
    //     .update({"admin": 1, "email": "admin", "password": "123"});
    final state = context.read<UserCubit>().state;
    print("state is");
    print(state.email);
  }

  Future login(String? email, String? password) async {
    User? user;
    if (email != null && password != null) {
      user = await dbService.findUser(email);
    }
    if (user != null && user.password == password) {
      if (user.admin!) {
        // ignore: use_build_context_synchronously
        context.read<UserCubit>().update(user);

        Navigator.pushReplacement<void, void>(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const AdminPage(),
          ),
        );
        return;
      }
      await Navigator.pushReplacement<void, void>(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const UserPage(),
        ),
      );
    }
    setState(() {
      errorMsg = true;
    });
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await initDB());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Opacity(
                opacity: errorMsg ? 1 : 0,
                child: const Text(
                  "Invalid Credentials!",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                onChanged: (value) => {
                  setState(() {
                    emailVal = value;
                  }),
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                onChanged: (value) => {
                  setState(() {
                    passwordVal = value;
                  }),
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.red[600]),
                  onPressed: () async {
                    await login(emailVal, passwordVal);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
