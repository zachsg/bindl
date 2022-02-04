import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/features/cookbook/cookbook_controller.dart';
import 'package:bodai/features/meal_plan/meal_plan_controller.dart';
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
      state.add(meal);
    }

    await ref.read(userProvider).load();
    ref.read(userProvider).clearIngredientsToUse();
    ref.read(mealPlanProvider).load();
    ref.read(cookbookProvider.notifier).load();
    ref.read(bestMealProvider.notifier).compute();
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
