import 'dart:io';

import 'package:day_picker/day_picker.dart';
import 'package:day_picker/model/day_in_week.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menu_app/cubits/dbService_cubit.dart';
import 'package:menu_app/cubits/meal_cubit.dart';
import 'package:menu_app/models/meal_model.dart';
import 'package:menu_app/services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DatabaseService? dbService;
  int _selectedIndex = 0;
  File? _selectedImage;
  String? imagePath;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String titleVal = "";
  String descriptionVal = "";
  List<String> weekdays = [];

  onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => dbService = context.read<DbserviceCubit>().state);
      List<Meal>? mealList = await dbService?.getMeals();
      if (mealList != null) {
        context.read<MealsCubit>().update(mealList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Meal Planner')),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red[600],
          labelColor: Colors.red[600],
          tabs: const [
            Tab(text: 'Meals'),
            Tab(text: 'Order'),
          ],
          onTap: onItemTapped,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMealsTab(),
          _buildOrderTab(),
        ],
      ),
      floatingActionButton: Opacity(
        opacity: _selectedIndex == 0 ? 1 : 0,
        child: FloatingActionButton(
          backgroundColor: Colors.red[600],
          onPressed: () {
            _showAddMealDialog(context);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMealsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Expanded(
            child: ListView(
              children: [
                for (var meal in context.read<MealsCubit>().state)
                  Column(
                    children: [
                      Slidable(
                        startActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) async {
                                await dbService!.deleteMeal(meal);
                                List<Meal>? mealList =
                                    await dbService?.getMeals();
                                if (mealList != null) {
                                  setState(() {
                                    context.read<MealsCubit>().update(mealList);
                                  });
                                }
                              },
                              backgroundColor: Colors.red.shade700,
                              icon: Icons.delete,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ],
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            leading: Image.file(
                              File(
                                meal.image!,
                              ),
                              width: 80,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            title: Text(meal.title!),
                            subtitle: Text(meal.description!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("S ",
                                    style: TextStyle(
                                        color: meal.days[0]
                                            ? Colors.red[600]
                                            : Colors.grey)),
                                Text("M ",
                                    style: TextStyle(
                                        color: meal.days[1]
                                            ? Colors.red[600]
                                            : Colors.grey)),
                                Text("T ",
                                    style: TextStyle(
                                        color: meal.days[2]
                                            ? Colors.red[600]
                                            : Colors.grey)),
                                Text("W ",
                                    style: TextStyle(
                                        color: meal.days[3]
                                            ? Colors.red[600]
                                            : Colors.grey)),
                                Text("T ",
                                    style: TextStyle(
                                        color: meal.days[4]
                                            ? Colors.red[600]
                                            : Colors.grey)),
                                Text("F ",
                                    style: TextStyle(
                                        color: meal.days[5]
                                            ? Colors.red[600]
                                            : Colors.grey)),
                                Text("S ",
                                    style: TextStyle(
                                        color: meal.days[6]
                                            ? Colors.red[600]
                                            : Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog(BuildContext context) {
    final List<DayInWeek> _days = [
      DayInWeek("S", dayKey: "0"),
      DayInWeek("M", dayKey: "1"),
      DayInWeek("T", dayKey: "2"),
      DayInWeek("W", dayKey: "3"),
      DayInWeek("T", dayKey: "4"),
      DayInWeek("F", dayKey: "5"),
      DayInWeek("S", dayKey: "6"),
    ];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Center(child: Text('Add Meal')),
            scrollable: true,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                GestureDetector(
                    onTap: () async {
                      final XFile? image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _selectedImage = File(image.path);
                          imagePath = image.path;
                        });
                        setStateDialog(() {});
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                        color: Colors.grey[100],
                      ),
                      child: _selectedImage == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text("Choose Image",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImage!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                    )),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  onChanged: (value) => {
                    setState(() {
                      titleVal = value;
                    })
                  },
                  decoration: InputDecoration(labelText: 'Meal Title'),
                ),
                TextField(
                  controller: _descriptionController,
                  onChanged: (value) => {
                    setState(() {
                      descriptionVal = value;
                    })
                  },
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 30),
                SelectWeekDays(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  days: _days,
                  border: false,
                  width: MediaQuery.of(context).size.width / 1.4,
                  boxDecoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onSelect: (values) {
                    setState(() {
                      weekdays = values;
                    });
                    print(weekdays);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => {Navigator.pop(context)},
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (titleVal != "" &&
                      descriptionVal != "" &&
                      imagePath != null) {
                    Meal newMeal = Meal(
                        title: titleVal,
                        description: descriptionVal,
                        image: imagePath);
                    for (var day in weekdays) {
                      newMeal.days[int.parse(day)] = true;
                    }
                    dbService?.addMeal(newMeal);
                    List<Meal>? mealList = await dbService?.getMeals();
                    if (mealList != null) {
                      context.read<MealsCubit>().update(mealList);
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
      },
    ).then((val) {
      setState(() {
        _selectedImage = null;
        imagePath = null;
        titleVal = "";
        descriptionVal = "";
        weekdays = [];
        _titleController.clear();
        _descriptionController.clear();
      });
    });
  }

  Widget _buildOrderTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Choose a Meal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Example count
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: Image.asset('assets/pizza.jpg',
                            width: 90, height: 90),
                        title: Text('Meal Option $index'),
                        subtitle: Text('Description of meal option $index'),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Order'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
