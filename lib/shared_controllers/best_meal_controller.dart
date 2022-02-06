import 'package:bodai/features/cookbook/controllers/ingredients_search_controller.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/xdata.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';

class BestMealController extends StateNotifier<Meal> {
  BestMealController({required this.ref})
      : super(const Meal(
          id: -1,
          owner: '',
          name: '',
          servings: 1,
          duration: 10,
          imageURL: '',
          steps: [],
          ingredients: [],
          tags: [],
          allergies: [],
          comments: [],
        ));

  final Ref ref;

  List<MapEntry<Tag, int>> _userCuisineTagsSorted = [];
  List<MapEntry<Tag, int>> _userMealTypeTagsSorted = [];
  Map<Tag, int> _userPalateTagsSorted = {};

  final fakeMeal = const Meal(
    id: -1,
    owner: '',
    name: '',
    servings: 1,
    duration: 10,
    imageURL: '',
    steps: [],
    ingredients: [],
    tags: [],
    allergies: [],
    comments: [],
  );

  void compute() {
    _userCuisineTagsSorted = _getSortedTags(Tags.cuisineTags);
    _userMealTypeTagsSorted = _getSortedTags(Tags.mealTypeTags);

    ref.read(userProvider).tags.forEach((key, value) {
      if (Tags.palateTags.contains(key)) {
        _userPalateTagsSorted[key] = value;
      }
    });

    state = bestMeal() ?? fakeMeal;
  }

  Future<void> undoSwipe(Meal meal) async {
    await ref
        .read(userProvider.notifier)
        .setRating(meal.id, meal.tags, Rating.neutral);

    ref.read(mealPlanProvider.notifier).load();

    compute();
  }

  List<MapEntry<Tag, int>> _getSortedTags(List<Tag> toSort) {
    Map<Tag, int> userTagMap = {};

    ref.read(userProvider).tags.forEach((key, value) {
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

  Meal? bestMeal() {
    var meals = List<Meal>.from(ref.read(mealsProvider));

    Meal? bestMeal; // = fakeMeal;

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

    for (var ingredient in ref.read(ingredientsSearchProvider)) {
      for (var i in mealIngredientsList) {
        if (i.contains(ingredient.toLowerCase())) {
          hasNumMatches += 1;
          break;
        }
      }
    }

    if (ref.read(ingredientsSearchProvider).length == hasNumMatches) {
      return meal;
    } else {
      return null;
    }
  }

  int _containsXIngredients(Meal meal) {
    var hasNumMatches = 0;

    var mealIngredientsList = meal.ingredients.map((e) =>
        e.name.split(',').first.replaceAll(optionalLabel, '').toLowerCase());

    for (var ingredient in ref.read(ingredientsSearchProvider)) {
      if (mealIngredientsList.contains(ingredient.toLowerCase())) {
        hasNumMatches += 1;
        break;
      }
    }

    return hasNumMatches;
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
          if (_userPalateTagsSorted.containsKey(tag)) {
            if (mealsAndRanksMap.containsKey(meal)) {
              mealsAndRanksMap[meal] =
                  mealsAndRanksMap[meal]! + (_userPalateTagsSorted[tag] as int);
            } else {
              mealsAndRanksMap[meal] = _userPalateTagsSorted[tag] as int;
            }
          }
        }
      }
    }

    if (mealsWithoutAbhorIngredients.isNotEmpty) {
      for (var meal in mealsWithoutAbhorIngredients) {
        for (var tag in meal.tags) {
          if (_userPalateTagsSorted.containsKey(tag)) {
            if (mealsAndRanksMap.containsKey(meal)) {
              mealsAndRanksMap[meal] =
                  mealsAndRanksMap[meal]! + (_userPalateTagsSorted[tag] as int);
            } else {
              mealsAndRanksMap[meal] = _userPalateTagsSorted[tag] as int;
            }
          }
        }
      }
    }

    if (mealsNotInCookbook.isNotEmpty) {
      for (var meal in mealsNotInCookbook) {
        for (var tag in meal.tags) {
          if (_userPalateTagsSorted.containsKey(tag)) {
            if (mealsAndRanksMap.containsKey(meal)) {
              mealsAndRanksMap[meal] =
                  mealsAndRanksMap[meal]! + (_userPalateTagsSorted[tag] as int);
            } else {
              mealsAndRanksMap[meal] = _userPalateTagsSorted[tag] as int;
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
      if (meal.tags.contains(_userCuisineTagsSorted[0].key)) {
        bestMeal = meal;
        break;
      } else if (meal.tags.contains(_userCuisineTagsSorted[1].key)) {
        bestMeal = meal;
        break;
      } else if (meal.tags.contains(_userCuisineTagsSorted[2].key)) {
        bestMeal = meal;
        break;
      } else if (meal.tags.contains(_userCuisineTagsSorted[3].key)) {
        bestMeal = meal;
        break;
      } else if (meal.tags.contains(_userCuisineTagsSorted[4].key)) {
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
      ref.read(userProvider).allergies.forEach((key, value) {
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
      if (!ref.read(userProvider).recipesDisliked.contains(meal.id)) {
        mealsNotDisliked.add(meal);
      }
    }

    return mealsNotDisliked;
  }

  List<Meal> _getMealsNotInCookbook(List<Meal> meals) {
    List<Meal> mealsNotInCookbook = [];

    for (var meal in meals) {
      if (!ref.read(userProvider).recipesLiked.contains(meal.id)) {
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

        isAbhor = ref
            .read(userProvider)
            .abhorIngredients
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

        isAdore = ref
            .read(userProvider)
            .adoreIngredients
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
}
