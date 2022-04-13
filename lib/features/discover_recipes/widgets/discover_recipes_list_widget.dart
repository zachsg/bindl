import 'package:bodai/features/discover_recipes/recipe_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../pantry/pantry_controller.dart';
import '../../pantry/pantry_view.dart';
import '../discover_recipes_controller.dart';
import '../recipe_controller.dart';

final recipesFutureProvider = FutureProvider<List<Recipe>>((ref) {
  return ref.watch(discoverRecipesProvider.notifier).load();
});

class DiscoverRecipesListWidget extends ConsumerWidget {
  const DiscoverRecipesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureRecipes = ref.watch(recipesFutureProvider);

    return futureRecipes.when(
      data: (recipes) => recipes.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No recipes found!\nTry changing your filters.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            )
          : ref.watch(addingIngredientsToPantryProvider)
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      crossAxisCount: 2,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final recipe = recipes[index];

                      final percentageOwned = ref
                          .read(recipeProvider.notifier)
                          .percentageOfIngredientsAlreadyOwned(
                              recipe: recipe, inPantry: true);

                      final percentageShopping = ref
                          .read(recipeProvider.notifier)
                          .percentageOfIngredientsAlreadyOwned(
                              recipe: recipe, inPantry: false);

                      return Padding(
                        padding: EdgeInsets.only(
                            top: index == 0 || index == 1 ? 8.0 : 0.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(pantryProvider.notifier)
                                  .ingredientsInPantryFrom(recipe);

                              ref
                                  .read(pantryProvider.notifier)
                                  .ingredientsInFridgeFrom(recipe);

                              ref
                                  .read(recipeProvider.notifier)
                                  .setupSelf(recipes[index].id!);

                              Navigator.pushNamed(
                                  context, RecipeView.routeName);
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: recipe.imageUrl,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.restaurant_menu),
                                        ),
                                        Positioned(
                                          right: 4,
                                          top: 4,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            child: Container(
                                              height: 36,
                                              width: 48,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              child: percentageShopping +
                                                          percentageOwned >=
                                                      1
                                                  ? IconButton(
                                                      onPressed: () {
                                                        const snackBar =
                                                            SnackBar(
                                                          content: Text(
                                                              'All of the ingredients are already either in your pantry or shopping list.'),
                                                        );
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .removeCurrentSnackBar();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                      },
                                                      icon: const Icon(
                                                        Icons.check,
                                                        size: 22,
                                                      ),
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        const title =
                                                            'Add To Shopping List';
                                                        const widget = Text(
                                                            'Do you want to add the '
                                                            'missing ingredients to your shopping list?');

                                                        _showMyDialog(
                                                            context,
                                                            title,
                                                            widget,
                                                            ref,
                                                            recipe);
                                                      },
                                                      icon: const Icon(
                                                        Icons.shopping_basket,
                                                        size: 22,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                    vertical: 2.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          recipe.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                    vertical: 2.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${recipe.prepTime + recipe.cookTime}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      Text(
                                        ' min',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.restaurant, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${recipe.ingredients.length}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          ' ingredients',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4.0,
                                    right: 4.0,
                                    top: 2.0,
                                    bottom: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.kitchen, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${(percentageOwned * 100).floor()}%',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.shopping_basket_outlined,
                                          size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${(percentageShopping * 100).ceil()}%',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      error: (e, st) => const Center(child: Text('Error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String title, Widget widget,
      WidgetRef ref, Recipe recipe) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: widget),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add Ingredients'),
              onPressed: () async {
                ref.read(addingIngredientsToPantryProvider.notifier).state =
                    true;

                Navigator.of(context).pop();

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
                    final i2 = ref
                        .read(pantryProvider.notifier)
                        .ingredientWithId(i.id)
                        .ingredient;

                    await ref
                        .read(pantryProvider.notifier)
                        .addIngredientQuantities(i, i2);
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

                ref.read(addingIngredientsToPantryProvider.notifier).state =
                    false;
              },
            ),
          ],
        );
      },
    );
  }
}
