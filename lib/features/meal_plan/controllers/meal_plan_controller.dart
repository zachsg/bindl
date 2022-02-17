import 'package:bodai/features/meal_plan/models/plan_item.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/data/xdata.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pantry_controller.dart';
import 'shopping_list_controller.dart';

final mealPlanProvider =
    StateNotifierProvider<MealPlanController, List<PlanItem>>(
        (ref) => MealPlanController(ref: ref));

class MealPlanController extends StateNotifier<List<PlanItem>> {
  MealPlanController({required this.ref}) : super([]);

  final Ref ref;

  Future<void> load() async {
    if (supabase.auth.currentUser != null) {
      state.clear();

      var planItemsJson = await DB.loadMealPlan(supabase.auth.currentUser!.id);

      for (var json in planItemsJson) {
        var planItem = PlanItem.fromJson(json);
        for (var meal in ref.read(mealsProvider)) {
          if (meal.id == planItem.mealID) {
            state = [...state, planItem];
          }
        }
      }

      if (state.isEmpty) {
        await ref.read(pantryProvider.notifier).clear();
      } else {
        await ref.read(pantryProvider.notifier).load();
      }

      ref.read(shoppingListProvider).load();
    }
  }

  Future<void> updateMealDateInPlan(Meal meal, DateTime dateTime) async {
    var planItem = PlanItem(
        id: -1,
        name: 'default',
        updatedAt: DateTime.now().toIso8601String(),
        plannedFor: dateTime.toIso8601String(),
        mealID: meal.id);

    state = state.where((element) => element.mealID != meal.id).toList();
    state = [...state, planItem];

    await DB.updateMealPlanDate(
        planItem.mealID, 'default', planItem.plannedFor);
  }

  Future<void> addMealToPlan(Meal meal) async {
    var planItem = PlanItem(
        id: -1,
        name: 'default',
        updatedAt: DateTime.now().toIso8601String(),
        plannedFor: DateTime.now().toIso8601String(),
        mealID: meal.id);

    state = [...state, planItem];

    await DB.addMealToPlan(planItem.mealID, 'default', planItem.plannedFor);

    await load();
  }

  Future<void> removeFromMealPlan(Meal meal) async {
    state = state.where((element) => element.mealID != meal.id).toList();

    await DB.removeFromMealPlan(meal.id, 'default', DateTime.now());

    await load();
  }

  bool containsMeal(int id) {
    for (var item in state) {
      if (item.mealID == id) {
        return true;
      }
    }

    return false;
  }

  void removeAt(Meal meal) {
    state = state.where((element) => element.id != meal.id).toList();
  }
}
