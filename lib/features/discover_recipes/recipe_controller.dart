import 'package:bodai/features/discover_recipes/discover_recipes_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/cuisine.dart';
import '../../models/recipe.dart';
import '../../models/recipe_type.dart';

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
}
