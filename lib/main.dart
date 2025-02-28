import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/cubits/dbService_cubit.dart';
import 'package:menu_app/cubits/meal_cubit.dart';
import 'package:menu_app/cubits/user_cubit.dart';
import 'package:menu_app/models/user_model.dart';
import 'package:menu_app/pages/login_page.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(),
        ),
        BlocProvider<MealsCubit>(
          create: (_) => MealsCubit(),
        ),
        BlocProvider<DbserviceCubit>(create: (_) => DbserviceCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: const LoginPage(),
      ),
    );
  }
}
