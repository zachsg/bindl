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
        title: Text(meal.name),
      ),
      body: Column(
        children: [
          Image(
            image: NetworkImage(meal.imageURL),
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: meal.steps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${index + 1}: ${meal.steps[index]}'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
