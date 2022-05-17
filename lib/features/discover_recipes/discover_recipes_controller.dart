import 'dart:collection';

import 'package:bodai/features/pantry/pantry_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/recipe.dart';
import '../../providers/providers.dart';
import '../../providers/user_controller.dart';
import '../../services/db.dart';
import 'recipe_controller.dart';
import 'widgets/filter_recipes_widget.dart';

final recipesFutureProvider = FutureProvider<List<Recipe>>((ref) {
  return ref.watch(discoverRecipesProvider.notifier).load();
});

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
    final appliances = ref.watch(userProvider).appliances;

    state.clear();

    dynamic response;

    switch (ref.watch(mySavedRecipesProvider)) {
      case 0:
        response = await DB.loadDiscoverRecipesWith(
          diets: diets,
          cuisines: cuisines,
          allergies: allergies,
          appliances: appliances,
        );
        break;
      case 1:
        response = await DB.loadDiscoverRecipesIFollowWith(
          diets: diets,
          cuisines: cuisines,
          allergies: allergies,
          appliances: appliances,
          following: ref.watch(userProvider).following,
        );
        break;
      case 2:
        response = await DB.loadDiscoverRecipesISavedWith(
          diets: diets,
          cuisines: cuisines,
          allergies: allergies,
          appliances: appliances,
        );
        break;
      default:
        response = await DB.loadDiscoverRecipesWith(
          diets: diets,
          cuisines: cuisines,
          allergies: allergies,
          appliances: appliances,
        );
    }

    List<Recipe> recipes = [];

    if (response == null) {
      return state;
    }

    for (final recipeJson in response) {
      final recipe = Recipe.fromJson(recipeJson);

      bool hasAnyDiets = false;
      for (final d in recipe.diets) {
        if (diets.contains(d)) {
          hasAnyDiets = true;
          break;
        }
      }

      if (hasAnyDiets && cuisines.contains(recipe.cuisine)) {
        bool isAllergic = false;
        for (final allergy in recipe.allergies) {
          if (allergies.contains(allergy)) {
            isAllergic = true;
            break;
          }
        }
        if (!isAllergic) {
          bool hasAppliances = true;
          for (final appliance in recipe.appliances) {
            if (!appliances.contains(appliance)) {
              hasAppliances = false;
              break;
            }
          }

          if (hasAppliances) {
            recipes.add(recipe);
          }

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

    sortedRecipes.sort((a, b) {
      final percentageOwnedA = ref
          .read(recipeProvider.notifier)
          .percentageOfIngredientsAlreadyOwned(recipe: a, inPantry: true);

      final percentageShoppingA = ref
          .read(recipeProvider.notifier)
          .percentageOfIngredientsAlreadyOwned(recipe: a, inPantry: false);

      final percentageOwnedB = ref
          .read(recipeProvider.notifier)
          .percentageOfIngredientsAlreadyOwned(recipe: b, inPantry: true);

      final percentageShoppingB = ref
          .read(recipeProvider.notifier)
          .percentageOfIngredientsAlreadyOwned(recipe: b, inPantry: false);

      if (percentageOwnedA >= 1.0) {
        return 1;
      } else if (percentageOwnedB >= 1.0) {
        return -1;
      } else {
        return (percentageOwnedA + percentageShoppingA)
            .compareTo(percentageOwnedB + percentageShoppingB);
      }
    });

    for (final recipe in sortedRecipes.reversed) {
      state = [...state, recipe];
    }

    // for (final recipeJson in response) {
    //   state = [...state, Recipe.fromJson(recipeJson)];
    // }

    ref.read(loadingProvider.notifier).state = false;

    return state;
  }
}
