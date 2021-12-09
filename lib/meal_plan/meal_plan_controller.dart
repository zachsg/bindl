import 'package:bindl/meal_plan/meal.dart';
import 'package:bindl/shared/db.dart';
import 'package:flutter/material.dart';

class MealPlanController extends ChangeNotifier {
  bool _showingNew = true;

  final List<Meal> _meals = [];

  List<Meal> all() => _meals;

  bool showingNew() => _showingNew;

  void showNewMeals(bool onlyNew) {
    _showingNew = onlyNew;
    notifyListeners();
  }

  Future<void> loadMealsForIDs(List<int> ids) async {
    final data = await DB.loadMealsWithIDs(ids);

    _meals.clear();
    for (var json in data) {
      var meal = Meal.fromJson(json);
      _meals.add(meal);
    }

    notifyListeners();
  }

  Meal mealForID(int id) {
    Meal meal = const Meal(0, '', 0, 0, '', [], [], [], []);

    for (var m in _meals) {
      if (m.id == id) {
        meal = m;
        break;
      }
    }

    return meal;
  }
}
