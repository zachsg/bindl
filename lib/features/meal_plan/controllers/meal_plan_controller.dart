import 'package:bodai/features/meal_plan/models/plan_item.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/data/xdata.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
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

    _sort();
  }

  void _sort() {
    state.sort(((a, b) {
      if (DateTime.parse(a.plannedFor).isBefore(DateTime.parse(b.plannedFor))) {
        return 0;
      } else {
        return 1;
      }
    }));
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
    _sort();

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
      var meal = ref.read(mealsProvider.notifier).mealForID(item.mealID);

      if (meal.id == id) {
        return true;
      }
    }

    return false;
  }

  void removeAt(Meal meal) {
    state = state.where((element) => element.id != meal.id).toList();
  }

  Future<User> getUserWithID(String id) async {
    var userJSON = await DB.getUserWithID(id);

    if (userJSON != null) {
      return User.fromJson(userJSON);
    } else {
      return User(
        id: '',
        updatedAt: DateTime.now().toIso8601String(),
        name: bodaiLabel,
        tags: {},
        allergies: {},
        adoreIngredients: [],
        abhorIngredients: [],
        recipesLiked: [],
        recipesDisliked: [],
        servings: 2,
        numMeals: 2,
        pantry: [],
      );
    }
  }

  Future<void> addComment(Meal meal, String message) async {
    if (supabase.auth.currentUser != null) {
      var user = await getUserWithID(supabase.auth.currentUser!.id);

      var comment = Comment(
        authorID: supabase.auth.currentUser!.id,
        authorName: user.name,
        date: DateTime.now().toIso8601String(),
        message: message,
        reactions: [],
      );

      meal.comments.add(comment);

      var jsonComments = [];
      for (var comment in meal.comments) {
        jsonComments.add(comment.toJson());
      }

      await DB.addComment(meal.id, jsonComments);
    }
  }

  bool isMyMessage(String authorID, String mealOwnerID) {
    if (authorID == mealOwnerID) {
      return true;
    }

    return false;
  }
}
