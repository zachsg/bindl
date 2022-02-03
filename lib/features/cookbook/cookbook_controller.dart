import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cookbookProvider =
    ChangeNotifierProvider((ref) => CookbookController(ref: ref));

class CookbookController extends ChangeNotifier {
  CookbookController({required this.ref});

  final List<Meal> _meals = [];

  final Ref ref;

  List<Meal> get all => _meals;

  void findMealsWith(List<String> ingredients) {
    if (ingredients.isEmpty) {
      load();
    } else {
      _meals.clear();

      var ids = ref.read(userProvider).recipesLiked.toSet().toList();

      // List<Meal> history = [];
      // for (var meal in ref.read(mealsProvider)) {
      //   if (ids.contains(meal.id)) {
      //     history.add(meal);
      //   }
      // }

      // List<Meal> historySorted = [];

      // for (var i = 0; i < ids.length; i++) {
      //   var meal = history.firstWhere((meal) => meal.id == ids[i]);
      //   historySorted.add(meal);
      // }

      // if (ref.read(userProvider).sortFewerIngredients) {
      //   historySorted.sort(
      //       (a, b) => a.ingredients.length.compareTo(b.ingredients.length));
      // } else if (ref.read(userProvider).sortShortestCooktime) {
      //   historySorted.sort((a, b) => a.duration.compareTo(b.duration));
      // }

      List<Meal> history = [];

      for (var meal in ref.read(mealsProvider)) {
        if (ids.contains(meal.id)) {
          history.add(meal);
        }
      }

      if (ref.read(userProvider).sortFewerIngredients) {
        history.sort(
            (a, b) => a.ingredients.length.compareTo(b.ingredients.length));
      } else if (ref.read(userProvider).sortShortestCooktime) {
        history.sort((a, b) => a.duration.compareTo(b.duration));
      }

      for (var meal in history) {
        var hasNumMatches = 0;

        var mealIngredientsList = meal.ingredients
            .map((e) => e.name
                .split(',')
                .first
                .replaceAll('(optional', '')
                .toLowerCase())
            .toList();

        for (var ingredient in ingredients) {
          for (var i in mealIngredientsList) {
            if (i.toLowerCase().contains(ingredient.toLowerCase())) {
              hasNumMatches += 1;
              break;
            }
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

  void load() {
    _meals.clear();

    var ids = ref.read(userProvider).recipesLiked.toSet().toList();

    List<Meal> history = [];

    for (var meal in ref.read(mealsProvider)) {
      if (ids.contains(meal.id)) {
        history.add(meal);
      }
    }

    if (ref.read(userProvider).sortFewerIngredients) {
      history
          .sort((a, b) => a.ingredients.length.compareTo(b.ingredients.length));
    } else if (ref.read(userProvider).sortShortestCooktime) {
      history.sort((a, b) => a.duration.compareTo(b.duration));
    }

    if (ref.read(userProvider).sortLatest) {
      for (var i = 0; i < ids.length; i++) {
        var meal = history.firstWhere((meal) => meal.id == ids[i]);
        _meals.insert(0, meal);
      }
    } else {
      for (var meal in history) {
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
