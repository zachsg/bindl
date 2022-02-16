import 'package:bodai/data/xdata.dart';
import 'package:bodai/features/cookbook/controllers/ingredients_search_controller.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/features/cookbook/controllers/cookbook_controller.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class MealsController extends StateNotifier<List<Meal>> {
  MealsController({required this.ref}) : super([]);

  final Ref ref;

  Future<void> load() async {
    final data = await DB.loadAllMeals();

    state.clear();

    for (var json in data) {
      var meal = Meal.fromJson(json);
      state = [...state, meal];
    }

    await ref.read(userProvider.notifier).load();
    // ref.read(ingredientsSearchProvider.notifier).clearIngredientsToUse();
    await ref.read(mealPlanProvider.notifier).load();
    ref.read(cookbookProvider.notifier).load();
    ref.read(bestMealProvider.notifier).compute();
  }

  Meal mealForID(int id) {
    var meal = const Meal(
      id: -1,
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

    for (var item in state) {
      if (item.id == id) {
        meal = item;
        break;
      }
    }

    return meal;
  }
}
