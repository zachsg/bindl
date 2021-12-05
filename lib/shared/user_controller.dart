import 'package:bindl/meal_plan/meal.dart';
import 'package:bindl/shared/rating.dart';
import 'package:flutter/material.dart';

import 'allergy.dart';
import 'db.dart';
import 'tag.dart';
import 'user.dart';

class UserController extends ChangeNotifier {
  User _user = User(
    name: '',
    tags: {},
    allergies: {
      Allergy.soy: false,
      Allergy.gluten: false,
      Allergy.dairy: false,
      Allergy.egg: false,
      Allergy.shellfish: false,
      Allergy.sesame: false,
      Allergy.treeNuts: false,
      Allergy.peanuts: false,
      Allergy.meat: false,
    },
    adoreIngredients: [],
    abhorIngredients: [],
    recipes: [],
    recipesLiked: [],
    recipesDisliked: [],
  );

  bool _updatesPending = false;

  bool get updatePending => _updatesPending;
  void setUpdatesPending(bool updates) {
    _updatesPending = updates;
    notifyListeners();
  }

  List<int> recipes() => _user.recipes;
  List<int> recipesLiked() => _user.recipesLiked;
  List<int> recipesDisliked() => _user.recipesDisliked;

  void setAllergy({required Allergy allergy, bool isAllergic = true}) {
    _user.allergies[allergy] = isAllergic;
    notifyListeners();
  }

  Map<Allergy, bool> allergies() {
    return _user.allergies;
  }

  bool isAllergic(Allergy allergy) {
    return _user.allergies[allergy] ?? false;
  }

  void setAdoreIngredient(String ingredient) {
    _user.adoreIngredients.add(ingredient);
    notifyListeners();
  }

  void removeAdoreIngredient(String ingredient) {
    _user.adoreIngredients.removeWhere((element) => element == ingredient);
    notifyListeners();
  }

  List<String> adoreIngredients() {
    return _user.adoreIngredients;
  }

  void setAbhorIngredient(String ingredient) {
    _user.abhorIngredients.add(ingredient);
    notifyListeners();
  }

  void removeAbhorIngredient(String ingredient) {
    _user.abhorIngredients.removeWhere((element) => element == ingredient);
    notifyListeners();
  }

  List<String> abhorIngredients() {
    return _user.abhorIngredients;
  }

  void setHasAccount(bool hasAccount) {
    _user.hasAccount = hasAccount;
    notifyListeners();
  }

  bool hasAccount() {
    return _user.hasAccount;
  }

  void addTags(List<Tag> tags, bool isLike) {
    for (var tag in tags) {
      if (isLike) {
        if (_user.tags.containsKey(tag)) {
          _user.tags[tag] = _user.tags[tag]! + 1;
        } else {
          _user.tags[tag] = 1;
        }
      } else {
        if (_user.tags.containsKey(tag)) {
          _user.tags[tag] = _user.tags[tag]! - 1;
        } else {
          _user.tags[tag] = -1;
        }
      }
    }

    notifyListeners();
  }

  List<MapEntry<Tag, int>> sortedTags() {
    return _user.tags.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        return diff;
      });
  }

  Future<void> loadUserData() async {
    if (DB.currentUser != null) {
      final data = await DB.loadUserData();
      _user = User.fromJson(data);
    }
  }

  Future<bool> saveUserData() async {
    if (DB.currentUser != null) {
      final id = DB.currentUser!.id;
      final user = _user.toJson();

      final updates = {
        'id': id,
        'updated_at': DateTime.now().toIso8601String(),
        'username':
            user['name'] ?? DB.currentUser!.email?.split('@').first ?? '',
        'adore_ingredients': user['adore_ingredients'] ?? [],
        'abhor_ingredients': user['abhor_ingredients'] ?? [],
        'recipes_old_liked': user['recipes_old_liked'] ?? [],
        'recipes_old_disliked': user['recipes_old_disliked'] ?? [],
        'recipes': user['recipes'] ?? [],
        'tags': user['tags'] ?? {},
        'allergies': user['allergies'] ?? {},
      };

      final success = await DB.saveUserData(updates);
      if (success) {
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } else {
      // TODO: Not authenticated, handle error
      return false;
    }
  }

  /// Compute meal plan for User
  /// Set `recipes` property to list of integers of relevant meal IDs.
  Future<void> computeMealPlan() async {
    _user.clearRecipes();

    // Start with every meal in the database, filter from there
    var meals = await getAllMeals();

    // Strip out meals that user has allergies to
    List<Meal> mealsWithoutAllergies = getMealsWithoutAllergies(meals);

    // Strip out meals the user has explicity disliked
    List<Meal> mealsNotDisliked = getMealsNotDisliked(mealsWithoutAllergies);

    // Strip out meals with ingredients the user says they abhor
    List<Meal> mealsWithoutAbhorIngredients =
        getMealsWithoutAbhorIngredients(mealsNotDisliked);

    // TODO: Look into ingredients user says they like specifically?
    // TODO: Look into tags
    // CUisines tags (e.g. french vs italian)
    // Palate tags (e.g. sweet vs savory)
    // Meal type tags (e.g. soup vs salad)

    // Add the relevant meals to the user's meal plan
    for (var meal in mealsWithoutAbhorIngredients) {
      _user.recipes.add(meal.id);
    }

    // Set user's meal plan in database
    final id = DB.currentUser!.id;
    final user = _user.toJson();
    await DB.setMealPlan(id, user['recipes']);

    notifyListeners();
  }

  Future<List<Meal>> getAllMeals() async {
    var mealsJson = await DB.loadAllMeals();

    List<Meal> meals = [];
    for (var json in mealsJson) {
      var meal = Meal.fromJson(json);
      meals.add(meal);
    }

    return meals;
  }

  List<Meal> getMealsWithoutAllergies(List<Meal> meals) {
    List<Meal> mealsWithoutAllergies = [];

    for (var meal in meals) {
      var isAllergic = false;
      _user.allergies.forEach((key, value) {
        if (value) {
          if (meal.allergies.contains(key)) {
            isAllergic = true;
          }
        }
      });
      if (!isAllergic) {
        mealsWithoutAllergies.add(meal);
      }
    }

    return mealsWithoutAllergies;
  }

  List<Meal> getMealsNotDisliked(List<Meal> meals) {
    List<Meal> mealsNotDisliked = [];

    for (var meal in meals) {
      if (!_user.recipesDisliked.contains(meal.id)) {
        mealsNotDisliked.add(meal);
      }
    }

    return mealsNotDisliked;
  }

  List<Meal> getMealsWithoutAbhorIngredients(List<Meal> meals) {
    List<Meal> mealsWithoutAbhorIngredients = [];

    for (var meal in meals) {
      var isAbhor = false;
      for (var ingredient in meal.ingredients) {
        if (_user.abhorIngredients.contains(ingredient.name)) {
          isAbhor = true;
          break;
        }
      }

      if (!isAbhor) {
        mealsWithoutAbhorIngredients.add(meal);
      }
    }

    return mealsWithoutAbhorIngredients;
  }

  int getRating(int id) {
    if (_user.recipesLiked.contains(id)) {
      return Rating.values.indexOf(Rating.dislike);
    } else if (_user.recipesDisliked.contains(id)) {
      return Rating.values.indexOf(Rating.like);
    } else {
      return Rating.values.indexOf(Rating.neutral);
    }
  }

  Future<void> setRating(int id, Rating rating) async {
    final userID = DB.currentUser!.id;

    switch (rating) {
      case Rating.like:
        if (_user.recipesDisliked.contains(id)) {
          _user.recipesDisliked.remove(id);
          await DB.setRatings(userID, _user.recipesDisliked, false);
        }
        if (!_user.recipesLiked.contains(id)) {
          _user.recipesLiked.add(id);
          await DB.setRatings(userID, _user.recipesLiked, true);
        }

        break;
      case Rating.dislike:
        if (_user.recipesLiked.contains(id)) {
          _user.recipesLiked.remove(id);
          await DB.setRatings(userID, _user.recipesLiked, true);
        }
        if (!_user.recipesDisliked.contains(id)) {
          _user.recipesDisliked.add(id);
          await DB.setRatings(userID, _user.recipesDisliked, false);
        }

        break;
      default:
        if (_user.recipesLiked.contains(id)) {
          _user.recipesLiked.remove(id);
        }
        if (_user.recipesDisliked.contains(id)) {
          _user.recipesDisliked.remove(id);
        }
    }

    notifyListeners();
  }
}
