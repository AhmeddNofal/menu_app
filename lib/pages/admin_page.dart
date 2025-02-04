import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          onPressed: () {_showAddMealDialog(context);},
          child: const Icon(Icons.add, color: Colors.white,),
        ),
      ),
    );
  }

  Widget _buildMealsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // ElevatedButton(
          //   onPressed: () {},
          //   child: const Text('Add Meal'),
          // ),
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
                        title: Text('Meal Title $index'),
                        subtitle: Text('Description of meal $index'),
                        trailing: const Text('S M T W T F S'),
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

  void _showAddMealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Meal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Meal Title'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Weekdays (e.g., Mon, Wed, Fri)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
