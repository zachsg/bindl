import 'package:bodai/features/cookbook/sort_order_controller.dart';
import 'package:bodai/models/sort_order.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredients_search_controller.dart';

final cookbookProvider = StateNotifierProvider<CookbookController, List<Meal>>(
    (ref) => CookbookController(ref: ref));

class CookbookController extends StateNotifier<List<Meal>> {
  CookbookController({required this.ref}) : super([]);

  final Ref ref;

  void load() {
    state.clear();

    var ids = ref.read(userProvider).recipesLiked.toSet().toList();

    List<Meal> history = [];

    for (var meal in ref.read(mealsProvider)) {
      if (ids.contains(meal.id)) {
        history.add(meal);
      }
    }

    if (ref.read(sortOrderProvider) == SortOrder.fewest) {
      history
          .sort((a, b) => a.ingredients.length.compareTo(b.ingredients.length));
    } else if (ref.read(sortOrderProvider) == SortOrder.quickest) {
      history.sort((a, b) => a.duration.compareTo(b.duration));
    }

    if (ref.read(ingredientsSearchProvider).isEmpty) {
      if (ref.read(sortOrderProvider) == SortOrder.latest) {
        for (var i = 0; i < ids.length; i++) {
          var meal = history.firstWhere((meal) => meal.id == ids[i]);
          state = [meal, ...state];
        }
      } else {
        for (var meal in history) {
          state = [...state, meal];
        }
      }
    } else {
      for (var meal in history) {
        var hasNumMatches = 0;

        var mealIngredientsList = meal.ingredients
            .map((e) => e.name
                .split(',')
                .first
                .replaceAll('(optional', '')
                .toLowerCase())
            .toList();

        for (var ingredient in ref.read(ingredientsSearchProvider)) {
          for (var i in mealIngredientsList) {
            if (i.toLowerCase().contains(ingredient.toLowerCase())) {
              hasNumMatches += 1;
              break;
            }
          }
        }

        if (ref.read(ingredientsSearchProvider).length == hasNumMatches) {
          state = [...state, meal];
        }

        hasNumMatches = 0;
      }
    }

    if (state.isEmpty) {
      state = [];
    }
  }

  void add(Meal meal) {
    var alreadyCooked = false;

    for (var m in state) {
      if (m.id == meal.id) {
        alreadyCooked = true;
        break;
      }
    }

    if (!alreadyCooked) {
      state = [meal, ...state];
    }
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

    for (var m in state) {
      if (m.id == id) {
        meal = m;
        break;
      }
    }

    return meal;
  }
}
