import 'package:bindl/meal_plan/meal.dart';
import 'package:bindl/settings/settings_view.dart';
import 'package:flutter/material.dart';

import 'meal_plan_details_view.dart';

class MealPlanView extends StatelessWidget {
  const MealPlanView({Key? key}) : super(key: key);

  static const routeName = '/meal_plan';

  final List<Meal> meals = const [
    Meal(1, 'Hamburger'),
    Meal(2, 'Pho'),
    Meal(3, 'Salad'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.face),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView', // listview to restore position
        itemCount: meals.length,
        itemBuilder: (BuildContext context, int index) {
          final meal = meals[index];

          return ListTile(
              title: Text(meal.name),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  MealPlanDetailsView.routeName,
                  arguments: meal.toJson(),
                );
              });
        },
      ),
    );
  }
}
