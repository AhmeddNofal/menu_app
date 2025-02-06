import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:menu_app/cubits/dbService_cubit.dart';
import 'package:menu_app/cubits/meal_cubit.dart';
import 'package:menu_app/cubits/user_cubit.dart';
import 'package:menu_app/models/meal_model.dart';
import 'package:menu_app/models/order_model.dart';
import 'package:menu_app/services/databaseService.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  DatabaseService? dbService;
  List<String> weekdays = [];
  DateTime date = DateTime.now();
  String? dateFormat;
  String? curWeekday;
  static const weekdayIndexMap = {
    "sunday": 0,
    "monday": 1,
    "tuesday": 2,
    "wednesday": 3,
    "thursday": 4,
    "friday": 5,
    "saturday": 6,
  };
  int? weekdayIndex;
  Meal? mealOrdered;
  Order? todayOrder;
  String mealSearch1 = "";

  Meal? findMeal(int id) {
    for (var meal in context.read<MealsCubit>().state) {
      if (meal.id == id) {
        return meal;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        dbService = context.read<DbserviceCubit>().state;
        dateFormat = DateFormat('dd-MM-yyyy').format(date);
        curWeekday = DateFormat('EEEE').format(date).toLowerCase();
        weekdayIndex = weekdayIndexMap[curWeekday];
        print(weekdayIndex);
      });
      List<Meal>? mealList = await dbService?.getMeals();
      if (mealList != null) {
        context.read<MealsCubit>().update(mealList);
      }
      for (var m in mealList!) {
        print(m.days);
      }
      Order? order = await dbService?.getTodayOrder(
          context.read<UserCubit>().state.id!, dateFormat!);
      setState(() {
        todayOrder = order;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Order Meal')),
      ),
      body: todayOrder != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Your Order!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 25),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(findMeal(todayOrder!.mealId!)!.image!),
                    width: 180,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  findMeal(todayOrder!.mealId!)!.title!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
                Text(
                  findMeal(todayOrder!.mealId!)!.description!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          mealSearch1 = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Meals',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Color.fromARGB(106, 244, 241, 241),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                      child: ListView(
                    children: [
                      for (var meal in context.read<MealsCubit>().state)
                        if (meal.days[weekdayIndex!] == true &&
                            (mealSearch1 == "" ||
                                meal.title!
                                    .toLowerCase()
                                    .contains(mealSearch1.toLowerCase())))
                          Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  leading: Image.file(
                                    File(meal.image!),
                                    width: 80,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(meal.title!),
                                  subtitle: Text(meal.description!),
                                  trailing: mealOrdered == meal
                                      ? ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              mealOrdered = meal;
                                            });
                                          },
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(10),
                                            backgroundColor: Colors.green[600],
                                            // <-- Splash color
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              mealOrdered = meal;
                                            });
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(10),
                                            backgroundColor: Colors.red[600],
                                            // <-- Splash color
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                    ],
                  )),
                  Row(
                    children: [
                      Expanded(
                        child: mealOrdered != null
                            ? ElevatedButton(
                                onPressed: () async {
                                  Order? order = Order(
                                      mealId: mealOrdered!.id,
                                      userId:
                                          context.read<UserCubit>().state.id,
                                      date: dateFormat);
                                  await dbService?.addOrder(order);
                                  order = await dbService?.getTodayOrder(
                                      context.read<UserCubit>().state.id!,
                                      dateFormat!);
                                  setState(() {
                                    todayOrder = order;
                                  });
                                },
                                child: const Text(
                                  'Order',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.red[600],
                                  // <-- Splash color
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  'Order',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.red[200],
                                  // <-- Splash color
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
    );
  }
}
