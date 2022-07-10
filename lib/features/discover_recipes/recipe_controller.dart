import 'package:bodai/extensions.dart';
import 'package:bodai/features/discover_recipes/discover_recipes_controller.dart';
import 'package:bodai/features/discover_recipes/widgets/rating_button_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/xmodels.dart';
import '../../providers/other_user_controller.dart';
import '../../providers/providers.dart';
import '../../services/db.dart';
import '../pantry/pantry_controller.dart';
import 'recipe_view.dart';

final recipeProvider = StateNotifierProvider<RecipeController, Recipe>(
    (ref) => RecipeController(ref: ref));

class RecipeController extends StateNotifier<Recipe> {
  RecipeController({required this.ref})
      : super(Recipe(
            updatedAt: '',
            ownerId: '',
            name: '',
            cuisine: Cuisine.american,
            recipeType: RecipeType.dinner));

  final Ref ref;

  void setupSelf(Recipe recipe) {
    state = recipe;
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

      ingredientStrings.add('water');
      ingredientStrings.add('tap water');
      ingredientStrings.add('cold water');
      ingredientStrings.add('hot water');
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

  Future<User> creator() async {
    final data = await DB.loadUserWithId(state.ownerId);
    final user = User.fromJson(data);

    ref.read(otherUserIdProvider.notifier).state = state.ownerId;
    ref.read(otherUserProvider.notifier).setupSelf(user);

    return user;
  }

  Future<void> markCooked() async {
    await DB.markAsCooked(state.id!, ref.read(ratingProvider));
  }

  Future<void> addIngredientsToPantry(Recipe recipe) async {
    ref.read(addingIngredientsToPantryProvider.notifier).state = true;

    final List<Ingredient> unownedIngredients = [];

    final List<String> pantryStrings = [];
    for (final i in ref.read(pantryProvider)) {
      pantryStrings.add(i.ingredient.name.toLowerCase().trim());
    }

    if (!pantryStrings.contains('water')) {
      pantryStrings.add('water');
    }

    if (!pantryStrings.contains('hot water')) {
      pantryStrings.add('hot water');
    }
    if (!pantryStrings.contains('cold water')) {
      pantryStrings.add('cold water');
    }
    if (!pantryStrings.contains('tap water')) {
      pantryStrings.add('tap water');
    }

    final List<String> shoppingStrings = [];
    for (final i in ref.read(shoppingProvider)) {
      shoppingStrings.add(i.ingredient.name.toLowerCase().trim());
    }

    for (final i in recipe.ingredients) {
      if (!pantryStrings.contains(i.name.toLowerCase().trim())) {
        unownedIngredients.add(i);
      } else if (shoppingStrings.contains(i.name.trim().toLowerCase())) {
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
