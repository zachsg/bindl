import 'package:bodai/models/plan.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shopping_list_controller.dart';

final mealPlanProvider = StateNotifierProvider<MealPlanController, List<Meal>>(
    (ref) => MealPlanController(ref: ref));

class MealPlanController extends StateNotifier<List<Meal>> {
  MealPlanController({required this.ref}) : super([]);

  final Ref ref;

  Future<void> load() async {
    if (supabase.auth.currentUser != null) {
      state.clear();

      var planJson = await DB.loadMealPlan(supabase.auth.currentUser!.id);

      for (var json in planJson) {
        var plan = Plan.fromJson(json);
        for (var meal in ref.read(mealsProvider)) {
          if (meal.id == plan.mealID) {
            state = [...state, meal];
          }
        }
      }

      ref.read(shoppingListProvider).load();
    }
  }

  Future<void> addMealToPlan(Meal meal) async {
    state = [...state, meal];

    await DB.addMealToPlan(
        supabase.auth.currentUser!.id, meal.id, 'default', DateTime.now());

    await load();
  }

  Future<void> removeFromMealPlan(Meal meal) async {
    state = state.where((element) => element.id != meal.id).toList();

    await DB.removeFromMealPlan(
        supabase.auth.currentUser!.id, meal.id, 'default', DateTime.now());

    await load();
  }

  bool containsMeal(int id) {
    for (var meal in state) {
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
        recipes: [],
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
