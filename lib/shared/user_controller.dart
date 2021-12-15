import 'package:bindl/meal_plan/meal.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/shared/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> setAllergy(
      {required Allergy allergy,
      bool isAllergic = true,
      bool shouldPersist = false}) async {
    _user.allergies[allergy] = isAllergic;

    if (shouldPersist) {
      await persistChangesAndComputeMealPlan();
    }

    notifyListeners();
  }

  Future<void> persistChangesAndComputeMealPlan() async {
    await saveUserData();
    await computeMealPlan();
    final container = ProviderContainer();
    await container.read(mealPlanProvider).loadMealsForIDs(_user.recipes);
  }

  Map<Allergy, bool> allergies() {
    return _user.allergies;
  }

  bool isAllergic(Allergy allergy) {
    return _user.allergies[allergy] ?? false;
  }

  void setAdoreIngredient(
      {required String ingredient, bool shouldPersist = false}) {
    _user.adoreIngredients.add(ingredient);

    if (shouldPersist) {
      persistChangesAndComputeMealPlan();
    }

    notifyListeners();
  }

  void removeAdoreIngredient(
      {required String ingredient, bool shouldPersist = false}) {
    _user.adoreIngredients.removeWhere((element) => element == ingredient);

    if (shouldPersist) {
      persistChangesAndComputeMealPlan();
    }

    notifyListeners();
  }

  List<String> adoreIngredients() {
    return _user.adoreIngredients;
  }

  void setAbhorIngredient(
      {required String ingredient, bool shouldPersist = false}) {
    _user.abhorIngredients.add(ingredient);

    if (shouldPersist) {
      persistChangesAndComputeMealPlan();
    }

    notifyListeners();
  }

  void removeAbhorIngredient(
      {required String ingredient, bool shouldPersist = false}) {
    _user.abhorIngredients.removeWhere((element) => element == ingredient);

    if (shouldPersist) {
      persistChangesAndComputeMealPlan();
    }

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

    List<Meal> mealPlanMeals = [];

    while (getBestMeal(meals, mealPlanMeals) != null) {
      var meal = getBestMeal(meals, mealPlanMeals);
      mealPlanMeals.add(meal!);
    }

    // var option1 = getBestMeal(meals, mealPlanMeals);
    // if (option1 != null) {
    //   mealPlanMeals.add(option1);

    //   var option2 = getBestMeal(meals, mealPlanMeals);

    //   if (option2 != null) {
    //     mealPlanMeals.add(option2);
    //   }
    // }

    for (var meal in mealPlanMeals) {
      _user.recipes.add(meal.id);
    }

    final id = DB.currentUser!.id;
    final user = _user.toJson();
    await DB.setMealPlan(id, user['recipes']);

    notifyListeners();
  }

  Meal? getBestMeal(List<Meal> meals, List<Meal> mealPlan) {
    meals.removeWhere((meal) => mealPlan.contains(meal));

    // Strip out meals that user has allergies to
    List<Meal> mealsWithoutAllergies = getMealsWithoutAllergies(meals);

    // Strip out meals the user has explicity disliked
    List<Meal> mealsNotDisliked = getMealsNotDisliked(mealsWithoutAllergies);

    // Strip out meals with ingredients the user says they abhor
    List<Meal> mealsWithoutAbhorIngredients =
        getMealsWithoutAbhorIngredients(mealsNotDisliked);

    // Retain only meals that include at least 1 of the ingredients a user adores
    List<Meal> mealsWithAdoreIngredients =
        getMealsWithAdoreIngredients(mealsWithoutAbhorIngredients);

    var cuisineTags = [
      Tag.asian,
      Tag.japanese,
      Tag.thai,
      Tag.chinese,
      Tag.indian,
      Tag.greek,
      Tag.italian,
      Tag.french,
      Tag.american,
      Tag.latin,
    ];

    var carbTags = [
      Tag.lowCarb,
      Tag.highCarb,
      Tag.balancedCarb,
    ];

    var palateTags = [
      Tag.sweet,
      Tag.salty,
      Tag.savory,
      Tag.spicy,
    ];

    var userTopCuisineTag = getUserTagInTags(tags: cuisineTags, ranked: 1);
    var userTopCarbTag = getUserTagInTags(tags: carbTags, ranked: 1);
    var userTopPalateTag = getUserTagInTags(tags: palateTags, ranked: 1);

    var userSecondCuisineTag = getUserTagInTags(tags: cuisineTags, ranked: 2);
    var userSecondCarbTag = getUserTagInTags(tags: carbTags, ranked: 2);
    var userSecondPalateTag = getUserTagInTags(tags: palateTags, ranked: 2);

    var topTaggedAdoreMeals = getMealsWithTopUserTags(
        meals: mealsWithAdoreIngredients,
        userCuisineTag: userTopCuisineTag,
        userCarbTag: userTopCarbTag,
        userPalateTag: userTopPalateTag);

    var topTaggedWithoutAbhorMeals = getMealsWithTopUserTags(
        meals: mealsWithoutAbhorIngredients,
        userCuisineTag: userTopCuisineTag,
        userCarbTag: userTopCarbTag,
        userPalateTag: userTopPalateTag);

    var secondTaggedAdoreMeals = getMealsWithTopUserTags(
        meals: mealsWithAdoreIngredients,
        userCuisineTag: userSecondCuisineTag,
        userCarbTag: userSecondCarbTag,
        userPalateTag: userSecondPalateTag);

    var secondTaggedWithoutAbhorMeals = getMealsWithTopUserTags(
        meals: mealsWithoutAbhorIngredients,
        userCuisineTag: userSecondCuisineTag,
        userCarbTag: userSecondCarbTag,
        userPalateTag: userSecondPalateTag);

    if (mealsWithAdoreIngredients.isNotEmpty) {
      if (topTaggedAdoreMeals.isNotEmpty) {
        // print('adore > 1st tag');
        return topTaggedAdoreMeals.first;
      } else if (secondTaggedAdoreMeals.isNotEmpty) {
        // print('adore > 2nd tag');
        return secondTaggedAdoreMeals.first;
      } else {
        // print('adore > default');
        return mealsWithAdoreIngredients.first;
      }
    } else {
      if (topTaggedWithoutAbhorMeals.isNotEmpty) {
        // print('!abhor > 1st tag');
        return topTaggedWithoutAbhorMeals.first;
      } else if (secondTaggedWithoutAbhorMeals.isNotEmpty) {
        // print('!abhor > 2nd tag');
        return secondTaggedWithoutAbhorMeals.first;
      } else if (mealsWithoutAbhorIngredients.isNotEmpty) {
        // print('!abhor > default');
        return mealsWithoutAbhorIngredients.first;
      }
    }
  }

  List<Meal> getMealsWithTopUserTags(
      {required List<Meal> meals,
      required Tag userCuisineTag,
      required Tag userCarbTag,
      required Tag userPalateTag}) {
    List<Meal> mealPlanMeals = [];

    for (var meal in meals) {
      if (meal.tags.contains(userCuisineTag) &&
          meal.tags.contains(userCarbTag) &&
          meal.tags.contains(userPalateTag)) {
        mealPlanMeals.add(meal);

        if (mealPlanMeals.length == 2) {
          break;
        } else {
          continue;
        }
      }

      if (meal.tags.contains(userCarbTag) &&
          meal.tags.contains(userPalateTag)) {
        mealPlanMeals.add(meal);

        if (mealPlanMeals.length == 2) {
          break;
        } else {
          continue;
        }
      }

      if (meal.tags.contains(userCuisineTag) &&
          meal.tags.contains(userPalateTag)) {
        mealPlanMeals.add(meal);

        if (mealPlanMeals.length == 2) {
          break;
        } else {
          continue;
        }
      }

      if (meal.tags.contains(userCuisineTag) &&
          meal.tags.contains(userCarbTag)) {
        mealPlanMeals.add(meal);

        if (mealPlanMeals.length == 2) {
          break;
        } else {
          continue;
        }
      }

      if (meal.tags.contains(userCuisineTag) ||
          meal.tags.contains(userCarbTag) ||
          meal.tags.contains(userPalateTag)) {
        mealPlanMeals.add(meal);

        if (mealPlanMeals.length == 2) {
          break;
        } else {
          continue;
        }
      }
    }

    return mealPlanMeals;
  }

  Tag getUserTagInTags({required List<Tag> tags, required int ranked}) {
    Map<Tag, int> userTagMap = {};
    _user.tags.forEach((key, value) {
      if (tags.contains(key)) {
        userTagMap[key] = value;
      }
    });

    var userSortedTagMap = userTagMap.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        return diff;
      });

    return userSortedTagMap.first.key;
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
        var mealIngredient = ingredient.name
            .split(',')
            .first
            .replaceAll('(optional)', '')
            .trim()
            .toLowerCase();

        isAbhor = _user.abhorIngredients
            .where((element) => element.toLowerCase().contains(mealIngredient))
            .isNotEmpty;
        if (isAbhor) {
          break;
        }
      }

      if (!isAbhor) {
        mealsWithoutAbhorIngredients.add(meal);
      }
    }

    return mealsWithoutAbhorIngredients;
  }

  /// Returns a list of meals that contain the user's adored ingredients.
  /// Meals are sorted by number of adored ingredients from most to least.
  List<Meal> getMealsWithAdoreIngredients(List<Meal> meals) {
    List<Meal> mealsWithAdoreIngredients = [];
    Map<Meal, int> mealsAndCounts = {};

    for (var meal in meals) {
      var isAdore = false;
      for (var ingredient in meal.ingredients) {
        var mealIngredient = ingredient.name
            .split(',')
            .first
            .replaceAll('(optional)', '')
            .trim()
            .toLowerCase();

        isAdore = _user.adoreIngredients
            .where((element) => element.toLowerCase().contains(mealIngredient))
            .isNotEmpty;

        if (isAdore) {
          if (mealsAndCounts.containsKey(meal)) {
            mealsAndCounts[meal] = mealsAndCounts[meal]! + 1;
          } else {
            mealsAndCounts[meal] = 1;
          }
        }
      }
    }

    var sortedMeals = mealsAndCounts.keys.toList(growable: false)
      ..sort((k1, k2) => mealsAndCounts[k2]!.compareTo(mealsAndCounts[k1]!));

    mealsWithAdoreIngredients.addAll(sortedMeals);

    return mealsWithAdoreIngredients;
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

  Future<void> setRating(int id, List<Tag> tags, Rating rating) async {
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

        addTags(tags, true);
        await saveUserData();

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

        addTags(tags, false);
        await saveUserData();

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

  int servings() => _user.servings;

  Future<void> setServings(int servings) async {
    final userID = DB.currentUser!.id;

    final success = await DB.setServings(userID, servings);

    if (success) {
      _user.servings = servings;
      notifyListeners();
    }
  }
}
