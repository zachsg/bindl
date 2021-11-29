import 'package:bindl/meal_plan/meal.dart';
import 'package:bindl/shared/db.dart';
import 'package:flutter/material.dart';

class MealPlanController extends ChangeNotifier {
  final List<Meal> _meals = [];

  List<Meal> all() => _meals;

  Future<void> loadMealsForIDs(List<int> ids) async {
    final data = await DB.loadMealsWithIDs(ids);

    _meals.clear();
    for (var json in data) {
      var meal = Meal(json['id'], json['name']);
      _meals.add(meal);
    }

    notifyListeners();
  }
}
