import 'package:bodai/data/ingredients.dart';
import 'package:bodai/extensions.dart';
import 'package:bodai/features/discover_recipes/discover_recipes_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/cuisine.dart';
import '../../models/recipe.dart';
import '../../models/recipe_type.dart';
import '../../models/user.dart';
import '../../models/xmodels.dart';
import '../../providers/other_user_controller.dart';
import '../../services/db.dart';
import '../pantry/pantry_controller.dart';
import '../pantry/pantry_view.dart';
import '../profile/your_profile/your_profile_view.dart';
import 'recipe_view.dart';
import 'widgets/discover_recipes_list_widget.dart';

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

  double percentageOfIngredientsAlreadyOwned({
    required Recipe recipe,
    required bool inPantry,
  }) {
    final pantryIngredients = ref.read(pantryProvider);

    List<String> ingredientStrings = [];
    if (inPantry) {
      for (final i in pantryIngredients) {
        if (!i.toBuy) {
          ingredientStrings.add(i.ingredient.name);
        }
      }
    } else {
      for (final i in pantryIngredients) {
        if (i.toBuy) {
          ingredientStrings.add(i.ingredient.name);
        }
      }
    }

    double ownedCount = 0.0;
    for (final i in recipe.ingredients) {
      if (ingredientStrings.contains(i.name)) {
        ownedCount += 1;
      }
    }

    return ownedCount / recipe.ingredients.length;
  }

  Future<String> creatorName() async {
    final data = await DB.loadUserWithId(state.ownerId);
    final user = User.fromJson(data);

    ref.read(otherUserIdProvider.notifier).state = state.ownerId;
    ref.read(otherUserProvider.notifier).setupSelf(user);

    return user.name;
  }

  Future<void> markCooked() async {
    await DB.markAsCooked(state.id!);
  }

  Future<void> addIngredientsToPantry(Recipe recipe) async {
    ref.read(addingIngredientsToPantryProvider.notifier).state = true;

    final List<Ingredient> unownedIngredients = [];

    final List<int> pantryIds = [];
    for (final i in ref.read(pantryProvider)) {
      pantryIds.add(i.ingredient.id);
    }

    final List<int> shoppingIds = [];
    for (final i in ref.read(shoppingProvider)) {
      shoppingIds.add(i.ingredient.id);
    }

    for (final i in recipe.ingredients) {
      if (!pantryIds.contains(i.id)) {
        unownedIngredients.add(i);
      } else if (shoppingIds.contains(i.id)) {
        final i2 =
            ref.read(pantryProvider.notifier).ingredientWithId(i.id).ingredient;

        await ref.read(pantryProvider.notifier).addIngredientQuantities(i2, i);
      }
    }

    for (final i in unownedIngredients) {
      await ref.read(pantryProvider.notifier).addIngredient(
            ingredient: i,
            toBuy: true,
            buyTab: ref.watch(pantryTabIndexProvider) == 1,
          );
    }

    await ref.read(pantryProvider.notifier).load();

    ref.refresh(recipesFutureProvider);

    ref.read(addingIngredientsToPantryProvider.notifier).state = false;
  }
}
