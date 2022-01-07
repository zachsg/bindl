import 'dart:convert';

import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter/material.dart';

class MealPlanController extends ChangeNotifier {
  final List<Meal> _meals = [];
  final List<Meal> _allMealsInDB = [];

  List<Meal> get all => _meals;

  List<Meal> get allMealsInDB => _allMealsInDB;

  Future<void> loadMealsForIDs(List<int> ids) async {
    final data = await DB.loadMealsWithIDs(ids);

    final data2 = await DB.loadAllMeals();

    _meals.clear();

    _allMealsInDB.clear();

    for (var json in data2) {
      var meal = Meal.fromJson(json);
      _allMealsInDB.add(meal);
    }

    List<Meal> unorderedMeals = [];

    for (var json in data) {
      var meal = Meal.fromJson(json);
      unorderedMeals.add(meal);
    }

    for (var id in ids) {
      for (var meal in unorderedMeals) {
        if (meal.id == id) {
          _meals.add(meal);
        }
      }
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

    for (var m in _allMealsInDB) {
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
        name: 'bodai',
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

  Future<void> addComment(int mealID, String message) async {
    if (supabase.auth.currentUser != null) {
      var user = await getUserWithID(supabase.auth.currentUser!.id);

      var comment = Comment(
          authorID: supabase.auth.currentUser!.id,
          authorName: user.name,
          date: DateTime.now().toIso8601String(),
          message: message,
          reactions: []);

      var meal = await mealForID(mealID);

      meal.comments.add(comment);

      var jsonComments = [];
      for (var comment in meal.comments) {
        jsonComments.add(comment.toJson());
      }

      await DB.addComment(mealID, jsonComments);

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
