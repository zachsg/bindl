import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shopping_list_controller.dart';

final mealPlanProvider =
    ChangeNotifierProvider((ref) => MealPlanController(ref: ref));

class MealPlanController extends ChangeNotifier {
  MealPlanController({required this.ref});

  final Ref ref;

  final List<Meal> _meals = [];

  List<Meal> get all => _meals;

  void load() {
    _meals.clear();

    var ids = ref.read(userProvider).recipes;

    for (var id in ids) {
      for (var meal in ref.read(mealsProvider)) {
        if (meal.id == id) {
          _meals.add(meal);
        }
      }
    }

    notifyListeners();

    ref.read(shoppingListProvider).load();
  }

  void removeAt(int index) {
    _meals.removeAt(index);
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

      notifyListeners();
    }
  }

  bool isMyMessage(String authorID, String mealOwnerID) {
    if (authorID == mealOwnerID) {
      return true;
    }

    return false;
  }
}