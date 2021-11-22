import 'package:bindl/meal_plan/meal.dart';
import 'package:flutter/material.dart';

class MealPlanDetailsView extends StatelessWidget {
  const MealPlanDetailsView({
    Key? key,
    required this.mealJson,
  }) : super(key: key);

  static const routeName = '/meal_details';

  final Map<String, dynamic> mealJson;

  @override
  Widget build(BuildContext context) {
    var meal = Meal.fromJson(mealJson);

    return Scaffold(
      appBar: AppBar(
        title: Text('${meal.name} (ID: ${meal.id})'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
