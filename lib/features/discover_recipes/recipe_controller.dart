import 'package:bodai/extensions.dart';
import 'package:bodai/features/discover_recipes/discover_recipes_controller.dart';
import 'package:bodai/models/ingredient.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/cuisine.dart';
import '../../models/recipe.dart';
import '../../models/recipe_type.dart';
import '../pantry/pantry_controller.dart';

final recipeProvider = StateNotifierProvider<RecipeController, Recipe>(
    (ref) => RecipeController(ref: ref));

class RecipeController extends StateNotifier<Recipe> {
  RecipeController({required this.ref})
      : super(const Recipe(
            updatedAt: '',
            ownerId: '',
            name: '',
            cuisine: Cuisine.american,
            recipeType: RecipeType.dinner));

  final Ref ref;

  void setupSelf(int id) {
    state = ref
        .read(discoverRecipesProvider)
        .firstWhere((recipe) => recipe.id == id);
  }

  String crossReferencedRecipeIngredientsWithPantry(Recipe recipe) {
    var mutualIngredients = '';

    final pantryIngredients = ref.read(pantryProvider);

    for (final ingredient in recipe.ingredients) {
      for (final pantryIngredient in pantryIngredients) {
        if (ingredient.name.toLowerCase() ==
            pantryIngredient.ingredient.name.toLowerCase()) {
          if (mutualIngredients.isEmpty) {
            mutualIngredients += ingredient.name.capitalize();
          } else {
            mutualIngredients += ', ${ingredient.name.capitalize()}';
          }
        }
      }
    }

    if (mutualIngredients.endsWith(',')) {
      mutualIngredients =
          mutualIngredients.substring(0, mutualIngredients.length - 2);
    }

    return mutualIngredients;
  }
}
