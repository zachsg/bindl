import 'package:bodai/data/xdata.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/features/cookbook/controllers/cookbook_controller.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';
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
