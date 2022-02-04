import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    if (ref.read(userProvider).sortFewerIngredients) {
      history
          .sort((a, b) => a.ingredients.length.compareTo(b.ingredients.length));
    } else if (ref.read(userProvider).sortShortestCooktime) {
      history.sort((a, b) => a.duration.compareTo(b.duration));
    }

    if (ref.read(userProvider).ingredientsToUse.isEmpty) {
      if (ref.read(userProvider).sortLatest) {
        for (var i = 0; i < ids.length; i++) {
          var meal = history.firstWhere((meal) => meal.id == ids[i]);
          state.insert(0, meal);
        }
      } else {
        for (var meal in history) {
          state.add(meal);
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

        for (var ingredient in ref.read(userProvider).ingredientsToUse) {
          for (var i in mealIngredientsList) {
            if (i.toLowerCase().contains(ingredient.toLowerCase())) {
              hasNumMatches += 1;
              break;
            }
          }
        }

        if (ref.read(userProvider).ingredientsToUse.length == hasNumMatches) {
          state.add(meal);
        }

        hasNumMatches = 0;
      }
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
      state.insert(0, meal);
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
