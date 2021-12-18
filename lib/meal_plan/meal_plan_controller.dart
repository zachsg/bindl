import 'package:bindl/meal_plan/ingredient.dart';
import 'package:bindl/meal_plan/meal.dart';
import 'package:bindl/shared/db.dart';
import 'package:flutter/material.dart';

class MealPlanController extends ChangeNotifier {
  bool _showingNew = true;
  final List<Meal> _meals = [];
  final Map<String, Ingredient> _unifiedShoppingMap = {};
  List<Ingredient> _unifiedShoppingList = [];

  void buildUnifiedShoppingList(List<Ingredient> shoppingList) {
    _unifiedShoppingList = [];
    _unifiedShoppingMap.clear();

    for (var ingredient in shoppingList) {
      var dirty = false;

      var simpleIngredient = ingredient.name.split(',').first.trim();

      _unifiedShoppingMap.forEach((key, value) {
        if (key == simpleIngredient &&
            value.measurement == ingredient.measurement) {
          var name = ingredient.name;
          var measurement = ingredient.measurement;
          var quantity = ingredient.quantity + value.quantity;

          _unifiedShoppingMap[key] = Ingredient(
              name: name, quantity: quantity, measurement: measurement);
          dirty = true;
        }
      });

      if (!dirty) {
        _unifiedShoppingMap[ingredient.name] = ingredient;
      }
    }

    _unifiedShoppingMap.forEach((key, value) {
      _unifiedShoppingList.add(value);
    });

    notifyListeners();
  }

  List<Ingredient> unifiedShoppingList() => _unifiedShoppingList;

  List<Meal> all() => _meals;

  bool showingNew() => _showingNew;

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
}
