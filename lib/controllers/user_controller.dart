import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  User _user = User(
    id: '',
    updatedAt: DateTime.now().toIso8601String(),
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
      Allergy.seafood: false,
    },
    adoreIngredients: [],
    abhorIngredients: [],
    recipes: [],
    recipesLiked: [],
    recipesDisliked: [],
    servings: 1,
    pantry: [],
  );

  bool _updatesPending = false;

  bool get updatePending => _updatesPending;
  void setUpdatesPending(bool updates) {
    _updatesPending = updates;
    notifyListeners();
  }

  List<int> get recipes => _user.recipes;

  List<int> get recipesLiked => _user.recipesLiked;

  List<int> get recipesDisliked => _user.recipesDisliked;

  Map<Allergy, bool> get allergies => _user.allergies;

  List<String> get adoreIngredients => _user.adoreIngredients;

  List<String> get abhorIngredients => _user.abhorIngredients;

  bool get hasAccount => _user.hasAccount;

  int get servings => _user.servings;

  List<MapEntry<Tag, int>> get sortedTags => _user.tags.entries.toList()
    ..sort((e1, e2) {
      var diff = e2.value.compareTo(e1.value);
      return diff;
    });

  int getRating(int id) {
    if (_user.recipesLiked.contains(id)) {
      return Rating.values.indexOf(Rating.dislike);
    } else if (_user.recipesDisliked.contains(id)) {
      return Rating.values.indexOf(Rating.like);
    } else {
      return Rating.values.indexOf(Rating.neutral);
    }
  }

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

    notifyListeners();
  }

  bool isAllergic(Allergy allergy) {
    return _user.allergies[allergy] ?? false;
  }

  Future<void> setAdoreIngredient(
      {required String ingredient, bool shouldPersist = false}) async {
    _user.adoreIngredients.add(ingredient);

    if (shouldPersist) {
      await persistChangesAndComputeMealPlan();
    }

    notifyListeners();
  }

  Future<void> removeAdoreIngredient(
      {required String ingredient, bool shouldPersist = false}) async {
    _user.adoreIngredients.removeWhere((element) => element == ingredient);

    if (shouldPersist) {
      await persistChangesAndComputeMealPlan();
    }

    notifyListeners();
  }

  Future<void> setAbhorIngredient(
      {required String ingredient, bool shouldPersist = false}) async {
    _user.abhorIngredients.add(ingredient);

    if (shouldPersist) {
      await persistChangesAndComputeMealPlan();
    }

    notifyListeners();
  }

  Future<void> removeAbhorIngredient(
      {required String ingredient, bool shouldPersist = false}) async {
    _user.abhorIngredients.removeWhere((element) => element == ingredient);

    if (shouldPersist) {
      await persistChangesAndComputeMealPlan();
    }

    notifyListeners();
  }

  void setHasAccount(bool hasAccount) {
    _user.hasAccount = hasAccount;

    notifyListeners();
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

  Future<void> loadUserData() async {
    if (supabase.auth.currentUser != null) {
      final data = await DB.loadUserData();
      _user = User.fromJson(data);
    }

    notifyListeners();
  }

  Future<bool> saveUserData() async {
    if (supabase.auth.currentUser != null) {
      _user.setID(supabase.auth.currentUser!.id);
      _user.setUsername(
          supabase.auth.currentUser!.email?.split('@').first ?? 'anon');
      _user.setUpdatedAt(DateTime.now());
      final userJSON = _user.toJson();

      final success = await DB.saveUserData(userJSON);

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
    if (supabase.auth.currentUser == null) {
      return;
    }

    _user.clearRecipes();

    // Start with every meal in the database, filter from there
    var meals = await _getAllMeals();

    List<int> mealsAlreadyMadeAndGoodMatch = [];

    const maxMealsPerPlan = 4;

    while (_getBestMeal(meals) != null) {
      var meal = _getBestMeal(meals);

      if (!_user.recipesLiked.contains(meal!.id)) {
        _user.recipes.add(meal.id);
        meals.removeWhere((meal) => _user.recipes.contains(meal.id));
      } else if (_user.recipesLiked.contains(meal.id)) {
        meals.removeWhere(
            (meal) => mealsAlreadyMadeAndGoodMatch.contains(meal.id));
        mealsAlreadyMadeAndGoodMatch.add(meal.id);
      } else {
        meals.remove(meal);
      }

      if (_user.recipes.length == maxMealsPerPlan) {
        // Once meal plan has X # of recipes, we're done
        break;
      }
    }

    // If there weren't enough new meals found, serve up the good recipes
    // that the user already cooked.
    var setOfAlreadyMadeAndGoodMatches = mealsAlreadyMadeAndGoodMatch.toSet();
    if (_user.recipes.length < maxMealsPerPlan) {
      for (var meal in setOfAlreadyMadeAndGoodMatches) {
        _user.recipes.add(meal);

        if (_user.recipes.length == maxMealsPerPlan) {
          break;
        }
      }
    }

    final user = _user.toJson();
    await DB.setMealPlan(supabase.auth.currentUser!.id, user['recipes']);

    notifyListeners();
  }

  Meal? _getBestMeal(List<Meal> meals) {
    // Strip out any meals that I created
    List<Meal> mealsIDidNotMake = _getMealsThatIDidNotMake(meals);

    // Strip out meals that user has allergies to
    List<Meal> mealsWithoutAllergies =
        _getMealsWithoutAllergies(mealsIDidNotMake);

    // Strip out meals the user has explicity disliked
    List<Meal> mealsNotDisliked = _getMealsNotDisliked(mealsWithoutAllergies);

    // Strip out meals with ingredients the user says they abhor
    List<Meal> mealsWithoutAbhorIngredients =
        _getMealsWithoutAbhorIngredients(mealsNotDisliked);

    // Retain only meals that include at least 1 of the ingredients a user adores
    List<Meal> mealsWithAdoreIngredients =
        _getMealsWithAdoreIngredients(mealsWithoutAbhorIngredients);

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
      Tag.tangy,
    ];

    var mealTypeTags = [
      Tag.breakfast,
      Tag.soup,
      Tag.sandwich,
      Tag.pasta,
    ];

    var userTopCuisineTag = _getUserTagInTags(tags: cuisineTags, ranked: 1);
    var userTopCarbTag = _getUserTagInTags(tags: carbTags, ranked: 1);
    var userTopPalateTag = _getUserTagInTags(tags: palateTags, ranked: 1);

    var userSecondCuisineTag = _getUserTagInTags(tags: cuisineTags, ranked: 2);
    var userSecondCarbTag = _getUserTagInTags(tags: carbTags, ranked: 2);
    var userSecondPalateTag = _getUserTagInTags(tags: palateTags, ranked: 2);

    var topTaggedAdoreMeals = _getMealsWithTopUserTags(
        meals: mealsWithAdoreIngredients,
        userCuisineTag: userTopCuisineTag,
        userCarbTag: userTopCarbTag,
        userPalateTag: userTopPalateTag);

    var topTaggedWithoutAbhorMeals = _getMealsWithTopUserTags(
        meals: mealsWithoutAbhorIngredients,
        userCuisineTag: userTopCuisineTag,
        userCarbTag: userTopCarbTag,
        userPalateTag: userTopPalateTag);

    var secondTaggedAdoreMeals = _getMealsWithTopUserTags(
        meals: mealsWithAdoreIngredients,
        userCuisineTag: userSecondCuisineTag,
        userCarbTag: userSecondCarbTag,
        userPalateTag: userSecondPalateTag);

    var secondTaggedWithoutAbhorMeals = _getMealsWithTopUserTags(
        meals: mealsWithoutAbhorIngredients,
        userCuisineTag: userSecondCuisineTag,
        userCarbTag: userSecondCarbTag,
        userPalateTag: userSecondPalateTag);

    if (mealsWithAdoreIngredients.isNotEmpty) {
      if (topTaggedAdoreMeals.isNotEmpty) {
        return topTaggedAdoreMeals.first;
      } else if (secondTaggedAdoreMeals.isNotEmpty) {
        return secondTaggedAdoreMeals.first;
      } else {
        return mealsWithAdoreIngredients.first;
      }
    } else {
      if (topTaggedWithoutAbhorMeals.isNotEmpty) {
        return topTaggedWithoutAbhorMeals.first;
      } else if (secondTaggedWithoutAbhorMeals.isNotEmpty) {
        return secondTaggedWithoutAbhorMeals.first;
      } else if (mealsWithoutAbhorIngredients.isNotEmpty) {
        return mealsWithoutAbhorIngredients.first;
      }
    }
  }

  List<Meal> _getMealsWithTopUserTags(
      {required List<Meal> meals,
      required Tag userCuisineTag,
      required Tag userCarbTag,
      required Tag userPalateTag}) {
    List<Meal> mealPlanMeals = [];

    Map<Meal, int> mealsAndRanks = {};

    for (var meal in meals) {
      if (meal.tags.contains(userCuisineTag) &&
          meal.tags.contains(userCarbTag) &&
          meal.tags.contains(userPalateTag)) {
        mealsAndRanks[meal] = 1;
        continue;
      }

      if (meal.tags.contains(userCuisineTag) &&
          meal.tags.contains(userPalateTag)) {
        mealsAndRanks[meal] = 2;
        continue;
      }

      if (meal.tags.contains(userCarbTag) &&
          meal.tags.contains(userPalateTag)) {
        mealsAndRanks[meal] = 3;
        continue;
      }

      if (meal.tags.contains(userCuisineTag) &&
          meal.tags.contains(userCarbTag)) {
        mealsAndRanks[meal] = 4;
        continue;
      }

      if (meal.tags.contains(userCuisineTag) ||
          meal.tags.contains(userCarbTag) ||
          meal.tags.contains(userPalateTag)) {
        mealsAndRanks[meal] = 5;
        continue;
      }
    }

    var sortedMealsAndRanks = mealsAndRanks.entries.toList()
      ..sort((e1, e2) {
        var diff = e1.value.compareTo(e2.value);
        return diff;
      });

    for (var entry in sortedMealsAndRanks) {
      mealPlanMeals.add(entry.key);
    }

    return mealPlanMeals;
  }

  Tag _getUserTagInTags({required List<Tag> tags, required int ranked}) {
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

    Tag foundKey = Tag.american;
    var iteration = 1;
    for (var tag in userSortedTagMap) {
      if (iteration == ranked) {
        foundKey = tag.key;
        break;
      }
      iteration += 1;
    }

    return foundKey;
  }

  Future<List<Meal>> _getAllMeals() async {
    var mealsJson = await DB.loadAllMeals();

    List<Meal> meals = [];
    for (var json in mealsJson) {
      var meal = Meal.fromJson(json);
      meals.add(meal);
    }

    return meals;
  }

  List<Meal> _getMealsThatIDidNotMake(List<Meal> meals) {
    List<Meal> mealsIDidntMake = [];

    if (supabase.auth.currentUser != null) {
      for (var meal in meals) {
        if (meal.owner != supabase.auth.currentUser!.id) {
          mealsIDidntMake.add(meal);
        }
      }
    }

    return mealsIDidntMake;
  }

  List<Meal> _getMealsWithoutAllergies(List<Meal> meals) {
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

  List<Meal> _getMealsNotDisliked(List<Meal> meals) {
    List<Meal> mealsNotDisliked = [];

    for (var meal in meals) {
      if (!_user.recipesDisliked.contains(meal.id)) {
        mealsNotDisliked.add(meal);
      }
    }

    return mealsNotDisliked;
  }

  List<Meal> _getMealsWithoutAbhorIngredients(List<Meal> meals) {
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
  List<Meal> _getMealsWithAdoreIngredients(List<Meal> meals) {
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

  Future<void> setRating(int id, List<Tag> tags, Rating rating) async {
    if (supabase.auth.currentUser != null) {
      switch (rating) {
        case Rating.like:
          if (_user.recipesDisliked.contains(id)) {
            _user.recipesDisliked.remove(id);
            await DB.setRatings(
                supabase.auth.currentUser!.id, _user.recipesDisliked, false);
          }
          _user.recipesLiked.add(id);
          await DB.setRatings(
              supabase.auth.currentUser!.id, _user.recipesLiked, true);

          if (_user.recipes.contains(id)) {
            _user.recipes.remove(id);
          }

          addTags(tags, true);

          await saveUserData();

          break;
        case Rating.dislike:
          if (_user.recipesLiked.contains(id)) {
            _user.recipesLiked.remove(id);
            await DB.setRatings(
                supabase.auth.currentUser!.id, _user.recipesLiked, true);
          }
          if (!_user.recipesDisliked.contains(id)) {
            _user.recipesDisliked.add(id);
            await DB.setRatings(
                supabase.auth.currentUser!.id, _user.recipesDisliked, false);
          }

          if (_user.recipes.contains(id)) {
            _user.recipes.remove(id);
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
  }

  Future<void> setServings(int servings) async {
    if (supabase.auth.currentUser != null) {
      final success =
          await DB.setServings(supabase.auth.currentUser!.id, servings);

      if (success) {
        _user.servings = servings;

        notifyListeners();
      }
    }
  }
}
