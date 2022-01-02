import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';

class MealPlanController extends ChangeNotifier {
  bool _showingNew = true;
  final List<Meal> _meals = [];

  List<Meal> get all => _meals;

  bool get showingNew => _showingNew;

  void showNewMeals(bool onlyNew) {
    _showingNew = onlyNew;

    notifyListeners();
  }

  Future<void> loadMealsForIDs(List<int> ids) async {
    final data = await DB.loadMealsWithIDs(ids);

    _meals.clear();

    List<Meal> unorderedMeals = [];

    for (var json in data) {
      var meal = Meal.fromJson(json);
      unorderedMeals.add(meal);
    }

    for (var id in ids) {
      for (var meal in unorderedMeals) {
        if (meal.id == id) {
          _meals.add(meal);
        }
      }
    }

    notifyListeners();
  }

  Meal mealForID(int id) {
    Meal meal = const Meal(0, '', '', 0, 0, '', [], [], [], []);

    for (var m in _meals) {
      if (m.id == id) {
        meal = m;
        break;
      }
    }

    return meal;
  }

  Future<User> getUserWithID(String id) async {
    var userJSON = await DB.getUserWithID(id);

    if (userJSON != null) {
      return User.fromJson(userJSON);
    } else {
      return User(
        id: '',
        updatedAt: DateTime.now().toIso8601String(),
        name: 'bindl',
        tags: {},
        allergies: {},
        adoreIngredients: [],
        abhorIngredients: [],
        recipes: [],
        recipesLiked: [],
        recipesDisliked: [],
        pantry: [],
      );
    }
  }
}
