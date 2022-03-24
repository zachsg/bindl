import 'dart:collection';

import 'package:bodai/features/pantry/pantry_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/recipe.dart';
import '../../providers/providers.dart';
import '../../providers/user_controller.dart';
import '../../services/db.dart';
import 'widgets/filter_recipes_widget.dart';

final discoverRecipesProvider =
    StateNotifierProvider<DiscoverRecipesController, List<Recipe>>(
        (ref) => DiscoverRecipesController(ref: ref));

class DiscoverRecipesController extends StateNotifier<List<Recipe>> {
  DiscoverRecipesController({required this.ref}) : super([]);

  final Ref ref;

  Future<List<Recipe>> load() async {
    ref.read(loadingProvider.notifier).state = true;

    final diets = ref.watch(userProvider).diets;
    final cuisines = ref.watch(userProvider).cuisines;
    final allergies = ref.watch(userProvider).allergies;
    final onlySaved = ref.watch(mySavedRecipesProvider) == 1;

    state.clear();

    dynamic response;

    switch (ref.watch(mySavedRecipesProvider)) {
      case 0:
        response = await DB.loadDiscoverRecipesWith(
          diets: diets,
          cuisines: cuisines,
          allergies: allergies,
        );
        break;
      case 1:
        response = await DB.loadDiscoverRecipesIFollowWith(
          diets: diets,
          cuisines: cuisines,
          allergies: allergies,
          following: ref.watch(userProvider).followers,
        );
        break;
      case 2:
        response = await DB.loadDiscoverRecipesISavedWith(
          diets: diets,
          cuisines: cuisines,
          allergies: allergies,
        );
        break;
      default:
    }

    List<Recipe> recipes = [];

    if (response == null) {
      return state;
    }

    for (final recipeJson in response) {
      final recipe = Recipe.fromJson(recipeJson);
      if (diets.contains(recipe.diet) && cuisines.contains(recipe.cuisine)) {
        bool isAllergic = false;
        for (final allergy in recipe.allergies) {
          if (allergies.contains(allergy)) {
            isAllergic = true;
            break;
          }
        }
        if (!isAllergic) {
          recipes.add(recipe);
          isAllergic = false;
        }
      }
    }

    Map<Recipe, int> recipeMap = {};
    for (final recipe in recipes) {
      for (final pantryIngredient in ref.read(pantryProvider)) {
        final ingredientStrings = [];
        for (final i in recipe.ingredients) {
          ingredientStrings.add(i.name);
        }
        if (ingredientStrings.contains(pantryIngredient.ingredient.name)) {
          if (recipeMap.containsKey(recipe)) {
            recipeMap[recipe] = recipeMap[recipe]! + 1;
          } else {
            recipeMap[recipe] = 1;
          }
          continue;
        }
      }
      if (!recipeMap.containsKey(recipe)) {
        recipeMap[recipe] = 0;
      }
    }

    List<Recipe> sortedRecipes = [];
    var sortedKeys = recipeMap.keys.toList(growable: false)
      ..sort((k1, k2) => recipeMap[k2]!.compareTo(recipeMap[k1]!));
    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => recipeMap[k]);

    sortedMap.forEach((key, value) {
      sortedRecipes.add(key);
    });

    for (final recipe in sortedRecipes) {
      state = [...state, recipe];
    }

    // for (final recipeJson in response) {
    //   state = [...state, Recipe.fromJson(recipeJson)];
    // }

    ref.read(loadingProvider.notifier).state = false;

    return state;
  }
}
