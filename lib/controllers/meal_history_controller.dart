import 'package:bodai/controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealHistoryController extends ChangeNotifier {
  MealHistoryController({required this.ref});

  final List<Meal> _meals = [];

  final Ref ref;

  List<Meal> get all => _meals;

  void findMealsWith(List<String> ingredients) {
    if (ingredients.isEmpty) {
      load();
    } else {
      _meals.clear();

      var ids = ref.read(userProvider).recipesLiked;

      List<Meal> allHistory = [];
      for (var meal in ref.read(mealsProvider)) {
        if (ids.contains(meal.id)) {
          allHistory.add(meal);
        }
      }

      for (var meal in allHistory) {
        var hasNumMatches = 0;

        for (var ingredient in ingredients) {
          if (meal.ingredients
              .map((e) => e.name
                  .split(',')
                  .first
                  .replaceAll('(optional', '')
                  .toLowerCase())
              .contains(ingredient.toLowerCase())) {
            hasNumMatches += 1;
          }
        }

        if (ingredients.length == hasNumMatches) {
          _meals.add(meal);
        }

        hasNumMatches = 0;
      }
    }

    notifyListeners();
  }

  void load() async {
    _meals.clear();

    var ids = ref.read(userProvider).recipesLiked;

    for (var meal in ref.read(mealsProvider)) {
      if (ids.contains(meal.id)) {
        _meals.add(meal);
      }
    }

    notifyListeners();
  }

  void add(Meal meal) {
    var alreadyCooked = false;

    for (var m in _meals) {
      if (m.id == meal.id) {
        alreadyCooked = true;
        break;
      }
    }

    if (!alreadyCooked) {
      _meals.insert(0, meal);
    }

    notifyListeners();
  }

  Meal mealForID(int id) {
    Meal meal = const Meal(
      id: 0,
      owner: '',
      name: '',
      servings: 0,
      duration: 0,
      imageURL: '',
      steps: [],
      ingredients: [],
      tags: [],
      allergies: [],
      comments: [],
    );

    for (var m in _meals) {
      if (m.id == id) {
        meal = m;
        break;
      }
    }

    return meal;
  }
}
