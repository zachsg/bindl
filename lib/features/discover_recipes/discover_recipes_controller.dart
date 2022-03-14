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

    final response = await DB.loadDiscoverRecipesWith(
        diets: diets,
        cuisines: cuisines,
        allergies: allergies,
        onlySaved: onlySaved);

    List<Recipe> recipes = [];

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

    for (final recipe in recipes) {
      state = [...state, recipe];
    }

    // for (final recipeJson in response) {
    //   state = [...state, Recipe.fromJson(recipeJson)];
    // }

    ref.read(loadingProvider.notifier).state = false;

    return state;
  }
}
