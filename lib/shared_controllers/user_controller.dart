import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/features/cookbook/cookbook_controller.dart';
import 'package:bodai/features/meal_plan/meal_plan_controller.dart';
import 'package:bodai/features/meal_plan/pantry_controller.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController extends ChangeNotifier {
  UserController({required this.ref});

  final Ref ref;

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
    servings: 2,
    numMeals: 2,
    pantry: [],
  );

  List<MapEntry<Tag, int>> userCuisineTagsSorted = [];
  List<MapEntry<Tag, int>> userMealTypeTagsSorted = [];
  Map<Tag, int> userPalateTagsSorted = {};

  final List<String> _ingredientsToUse = [];

  List<String> get ingredientsToUse => _ingredientsToUse;

  List<int> get recipes => _user.recipes;

  List<int> get recipesLiked => _user.recipesLiked;

  List<int> get recipesDisliked => _user.recipesDisliked;

  Map<Allergy, bool> get allergies => _user.allergies;

  List<String> get adoreIngredients => _user.adoreIngredients;

  List<String> get abhorIngredients => _user.abhorIngredients;

  bool get hasAccount => _user.hasAccount;

  int get servings => _user.servings;

  int get numMeals => _user.numMeals;

  String get displayName => _user.name;

  void clearIngredientsToUse() {
    _ingredientsToUse.clear();

    notifyListeners();
  }

  void setIngredientToUse(String ingredient) {
    _ingredientsToUse.add(ingredient.toLowerCase().trim());

    notifyListeners();

    ref.read(cookbookProvider).findMealsWith(_ingredientsToUse);
  }

  void removeIngredientToUse(String ingredient) {
    _ingredientsToUse.remove(ingredient.toLowerCase().trim());

    notifyListeners();

    ref.read(cookbookProvider).findMealsWith(_ingredientsToUse);
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

  Future<void> setAllergy(
      {required Allergy allergy,
      bool isAllergic = true,
      bool shouldPersist = false}) async {
    _user.allergies[allergy] = isAllergic;

    if (shouldPersist) {
      await _persistChangesAndCompute();
    }

    notifyListeners();
  }

  Future<void> _persistChangesAndCompute() async {
    await save();

    ref.read(bestMealProvider.notifier).compute();

    notifyListeners();
  }

  bool isAllergic(Allergy allergy) {
    return _user.allergies[allergy] ?? false;
  }

  Future<void> setAdoreIngredient(
      {required String ingredient,
      required bool isAdore,
      bool shouldPersist = false}) async {
    if (isAdore) {
      _user.adoreIngredients.add(ingredient);
    } else {
      _user.adoreIngredients.removeWhere((element) => element == ingredient);
    }

    if (shouldPersist) {
      await _persistChangesAndCompute();
    }

    notifyListeners();
  }

  Future<void> setAbhorIngredient(
      {required String ingredient,
      required isAbhor,
      bool shouldPersist = false}) async {
    if (isAbhor) {
      _user.abhorIngredients.add(ingredient);
    } else {
      _user.abhorIngredients.removeWhere((element) => element == ingredient);
    }

    if (shouldPersist) {
      await _persistChangesAndCompute();
    }

    notifyListeners();
  }

  Future<void> setHasAccount(bool hasAccount) async {
    _user.hasAccount = hasAccount;

    notifyListeners();

    await save();
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

  Future<void> load() async {
    if (supabase.auth.currentUser != null) {
      final data = await DB.loadUserData();

      try {
        _user = User.fromJson(data);

        if (_user.recipes.isEmpty) {
          await ref.read(pantryProvider).clear();
        } else {
          await ref.read(pantryProvider).load();
        }

        ref.read(bestMealProvider.notifier).compute();
      } catch (e) {
        // await Auth.signOut();
      }

      var cuisineTags = [
        Tag.usa,
        Tag.canada,
        Tag.russia,
        Tag.germany,
        Tag.netherlands,
        Tag.vietnam,
        Tag.korea,
        Tag.china,
        Tag.taiwan,
        Tag.mongolia,
        Tag.thailand,
        Tag.japan,
        Tag.philippines,
        Tag.singapore,
        Tag.indonesia,
        Tag.italy,
        Tag.armenia,
        Tag.lebanon,
        Tag.israel,
        Tag.mexico,
        Tag.argentina,
        Tag.peru,
        Tag.france,
        Tag.greece,
        Tag.spain,
        Tag.portugal,
        Tag.england,
        Tag.ireland,
        Tag.wales,
        Tag.scotland,
        Tag.india,
        Tag.sriLanka,
        Tag.kenya,
        Tag.ethiopia,
        Tag.nigeria,
        Tag.cameroon,
        Tag.tunisia,
        Tag.southAfrica,
        Tag.morocco,
        Tag.egypt,
        Tag.iraq,
        Tag.pakistan,
        Tag.iran,
        Tag.saudiArabia,
        Tag.afghanistan,
        Tag.burma,
        Tag.cambodia,
        Tag.mali,
        Tag.ghana,
        Tag.guinea,
        Tag.zimbabwe,
        Tag.tanzania,
        Tag.sudan,
        Tag.uganda,
        Tag.jamaica,
        Tag.dominicanRepublic,
        Tag.bahamas,
        Tag.haiti,
        Tag.barbados,
        Tag.trinidad,
        Tag.cuba,
        Tag.puertoRico,
        Tag.costaRica,
        Tag.australia,
        Tag.newZealand,
      ];

      var palateTags = [
        Tag.sour,
        Tag.bitter,
        Tag.tangy,
        Tag.sweet,
        Tag.fruity,
        Tag.flaky,
        Tag.citrus,
        Tag.green,
        Tag.earthy,
        Tag.pungent,
        Tag.woody,
        Tag.nutty,
        Tag.sulfur,
        Tag.salty,
        Tag.light,
        Tag.rich,
        Tag.dry,
        Tag.saucy,
        Tag.spicy,
        Tag.hot,
        Tag.cold,
        Tag.bready,
        Tag.crunchy,
        Tag.protein,
        Tag.starchy,
        Tag.carby,
        Tag.fatty,
        Tag.simple,
        Tag.panFried,
        Tag.deepFried,
        Tag.seared,
        Tag.roasted,
        Tag.charred,
        Tag.smoked,
        Tag.grilled,
        Tag.braised,
        Tag.baked,
      ];

      var mealTypeTags = [
        Tag.soup,
        Tag.salad,
        Tag.sandwich,
        Tag.pasta,
        Tag.mainDish,
        Tag.breakfast,
        Tag.smallBite,
        Tag.drink,
        Tag.dessert,
      ];

      userCuisineTagsSorted = getSortedTags(cuisineTags);
      userMealTypeTagsSorted = getSortedTags(mealTypeTags);

      _user.tags.forEach((key, value) {
        if (palateTags.contains(key)) {
          userPalateTagsSorted[key] = value;
        }
      });
    }

    notifyListeners();
  }

  List<MapEntry<Tag, int>> getSortedTags(List<Tag> toSort) {
    Map<Tag, int> userTagMap = {};

    _user.tags.forEach((key, value) {
      if (toSort.contains(key)) {
        userTagMap[key] = value;
      }
    });

    return userTagMap.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        return diff;
      });
  }

  Future<bool> updateDisplayName(String displayName) async {
    if (supabase.auth.currentUser != null) {
      _user.setUsername(displayName);
      var saved = await save();

      return saved;
    }

    return false;
  }

  Future<bool> save() async {
    if (supabase.auth.currentUser != null) {
      _user.setID(supabase.auth.currentUser!.id);

      if (_user.name.isEmpty) {
        _user.setUsername(
            supabase.auth.currentUser!.email?.split('@').first ?? 'anon');
      }

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

  Meal? bestMeal() {
    var meals = List<Meal>.from(ref.read(mealsProvider));

    Meal? bestMeal;

    if (ref.read(bottomNavProvider) == 0) {
      while (_getBestMeal(meals) != null) {
        var meal = _getBestMeal(meals);

        if (meal != null) {
          bestMeal = meal;
          break;
        }
      }
    } else {
      List<Meal> foundMeals = [];

      while (_getBestMeal(meals) != null) {
        var meal = _getBestMeal(meals);

        if (meal != null) {
          foundMeals.add(meal);
        }

        meals.remove(meal);
      }

      if (foundMeals.isNotEmpty) {
        bestMeal = foundMeals.first;
      }

      bool foundBestMatch = false;

      for (var meal in foundMeals) {
        var mealWithAllIngredients = _doesMealContainAllIngredients(meal);
        if (mealWithAllIngredients != null) {
          bestMeal = mealWithAllIngredients;
          foundBestMatch = true;
          break;
        }
      }

      if (!foundBestMatch) {
        var topMatches = 0;

        for (var meal in foundMeals) {
          var numMatches = _containsXIngredients(meal);

          if (numMatches >= topMatches) {
            topMatches = numMatches;
            bestMeal = meal;
          }
        }
      }
    }

    return bestMeal;
  }

  Meal? _doesMealContainAllIngredients(Meal meal) {
    var hasNumMatches = 0;

    var mealIngredientsList = meal.ingredients.map((e) =>
        e.name.split(',').first.replaceAll(optionalLabel, '').toLowerCase());

    for (var ingredient in _ingredientsToUse) {
      for (var i in mealIngredientsList) {
        if (i.contains(ingredient.toLowerCase())) {
          hasNumMatches += 1;
          break;
        }
      }
    }

    if (_ingredientsToUse.length == hasNumMatches) {
      return meal;
    } else {
      return null;
    }
  }

  int _containsXIngredients(Meal meal) {
    var hasNumMatches = 0;

    var mealIngredientsList = meal.ingredients.map((e) =>
        e.name.split(',').first.replaceAll(optionalLabel, '').toLowerCase());

    for (var ingredient in _ingredientsToUse) {
      if (mealIngredientsList.contains(ingredient.toLowerCase())) {
        hasNumMatches += 1;
        break;
      }
    }

    return hasNumMatches;
  }

  Future<void> addMealToPlan(Meal meal) async {
    _user.recipes.add(meal.id);

    final user = _user.toJson();
    await DB.setMealPlan(supabase.auth.currentUser!.id, user['recipes']);

    ref.read(mealPlanProvider).load();

    notifyListeners();
  }

  Future<void> removeFromMealPlan(Meal meal) async {
    _user.recipes.remove(meal.id);

    notifyListeners();

    final user = _user.toJson();
    await DB.setMealPlan(supabase.auth.currentUser!.id, user['recipes']);
  }

  Future<void> removeFromCookbook(Meal meal) async {
    _user.recipesLiked.removeWhere((mealId) => meal.id == mealId);

    notifyListeners();

    ref.read(cookbookProvider).load();

    final user = _user.toJson();
    await DB.saveUserData(user);

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

    // Strip out meals already in user's cookbook
    List<Meal> mealsNotInCookbook = _getMealsNotInCookbook(mealsNotDisliked);

    // Strip out meals with ingredients the user says they abhor
    List<Meal> mealsWithoutAbhorIngredients =
        List.from(_getMealsWithoutAbhorIngredients(mealsNotInCookbook));

    // Retain only meals that include at least 1 of the ingredients a user adores
    List<Meal> mealsWithAdoreIngredients =
        _getMealsWithAdoreIngredients(mealsWithoutAbhorIngredients);

    Map<Meal, int> mealsAndRanksMap = {};
    if (mealsWithAdoreIngredients.isNotEmpty) {
      for (var meal in mealsWithAdoreIngredients) {
        for (var tag in meal.tags) {
          if (userPalateTagsSorted.containsKey(tag)) {
            if (mealsAndRanksMap.containsKey(meal)) {
              mealsAndRanksMap[meal] =
                  mealsAndRanksMap[meal]! + (userPalateTagsSorted[tag] as int);
            } else {
              mealsAndRanksMap[meal] = userPalateTagsSorted[tag] as int;
            }
          }
        }
      }
    }

    if (mealsWithoutAbhorIngredients.isNotEmpty) {
      for (var meal in mealsWithoutAbhorIngredients) {
        for (var tag in meal.tags) {
          if (userPalateTagsSorted.containsKey(tag)) {
            if (mealsAndRanksMap.containsKey(meal)) {
              mealsAndRanksMap[meal] =
                  mealsAndRanksMap[meal]! + (userPalateTagsSorted[tag] as int);
            } else {
              mealsAndRanksMap[meal] = userPalateTagsSorted[tag] as int;
            }
          }
        }
      }
    }

    if (mealsNotInCookbook.isNotEmpty) {
      for (var meal in mealsNotInCookbook) {
        for (var tag in meal.tags) {
          if (userPalateTagsSorted.containsKey(tag)) {
            if (mealsAndRanksMap.containsKey(meal)) {
              mealsAndRanksMap[meal] =
                  mealsAndRanksMap[meal]! + (userPalateTagsSorted[tag] as int);
            } else {
              mealsAndRanksMap[meal] = userPalateTagsSorted[tag] as int;
            }
          }
        }
      }
    }

    var mealsRanked = mealsAndRanksMap.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        return diff;
      });

    List<Meal> rankedMeals = [];
    for (var map in mealsRanked) {
      rankedMeals.add(map.key);
    }

    return _mealInBestCuisine(rankedMeals);
  }

  Meal? _mealInBestCuisine(List<Meal> meals) {
    Meal? bestMeal;

    for (var meal in meals) {
      if (meal.tags.contains(userCuisineTagsSorted[0].key)) {
        bestMeal = meal;
        break;
      } else if (meal.tags.contains(userCuisineTagsSorted[1].key)) {
        bestMeal = meal;
        break;
      } else if (meal.tags.contains(userCuisineTagsSorted[2].key)) {
        bestMeal = meal;
        break;
      } else if (meal.tags.contains(userCuisineTagsSorted[3].key)) {
        bestMeal = meal;
        break;
      } else if (meal.tags.contains(userCuisineTagsSorted[4].key)) {
        bestMeal = meal;
        break;
      }
    }

    if (bestMeal != null) {
      return bestMeal;
    } else if (meals.isNotEmpty) {
      return meals.first;
    } else {
      return null;
    }
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

  List<Meal> _getMealsNotInCookbook(List<Meal> meals) {
    List<Meal> mealsNotInCookbook = [];

    for (var meal in meals) {
      if (!_user.recipesLiked.contains(meal.id)) {
        mealsNotInCookbook.add(meal);
      }
    }

    return mealsNotInCookbook;
  }

  List<Meal> _getMealsWithoutAbhorIngredients(List<Meal> meals) {
    List<Meal> mealsWithoutAbhorIngredients = [];

    for (var meal in meals) {
      var isAbhor = false;

      for (var ingredient in meal.ingredients) {
        var mealIngredient = ingredient.name
            .split(',')
            .first
            .toLowerCase()
            .replaceAll(optionalLabel, '')
            .trim();

        isAbhor = _user.abhorIngredients
            .where((element) => element.toLowerCase().trim() == mealIngredient)
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
            .toLowerCase()
            .replaceAll(optionalLabel, '')
            .trim();

        isAdore = _user.adoreIngredients
            .where((element) => element.toLowerCase().trim() == mealIngredient)
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

          await save();

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

          await save();

          break;
        case Rating.neutral:
          if (_user.recipesLiked.contains(id)) {
            _user.recipesLiked.remove(id);
            await DB.setRatings(
                supabase.auth.currentUser!.id, _user.recipesLiked, true);
          }
          if (_user.recipesDisliked.contains(id)) {
            _user.recipesDisliked.remove(id);
            await DB.setRatings(
                supabase.auth.currentUser!.id, _user.recipesDisliked, false);
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

      ref.read(mealPlanProvider).load();

      ref.read(cookbookProvider).load();

      ref.read(bestMealProvider.notifier).compute();

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

  Future<void> setNumMeals(int numMeals) async {
    if (supabase.auth.currentUser != null) {
      final success =
          await DB.setNumMeals(supabase.auth.currentUser!.id, numMeals);

      if (success) {
        _user.numMeals = numMeals;

        notifyListeners();
      }
    }
  }
}
