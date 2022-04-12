import 'package:bodai/extensions.dart';
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
              : ListView.builder(
                  restorationId: 'discoverRecipesList',
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

                    var dietsFormatted = '';
                    for (final d in recipe.diets) {
                      dietsFormatted += '#${d.name.capitalize()} ';
                    }

                    return Column(
                      children: [
                        Container(
                          height: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          title: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: recipe.imageUrl,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.restaurant_menu),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.schedule,
                                                size: 18),
                                            const SizedBox(width: 4),
                                            Text(
                                                '${recipe.prepTime + recipe.cookTime} min'),
                                            const SizedBox(width: 16),
                                            const Icon(Icons.restaurant,
                                                size: 18),
                                            const SizedBox(width: 4),
                                            Text(
                                                '${recipe.ingredients.length} ingredients'),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Text(dietsFormatted),
                                          ),
                                          const SizedBox(width: 4),
                                          ClipOval(
                                            child: Container(
                                              width: 4,
                                              height: 4,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .shadow,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                                '#${recipe.cuisine.name.capitalize()}'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: percentageOwned == 1.0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    'You have all of the ingredients!',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                )
                              : percentageOwned + percentageShopping != 0.0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${(percentageOwned * 100).floor()}% of ingredients in pantry',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          ),
                                          Text(
                                            '${(percentageShopping * 100).ceil()}% of ingredients in shopping list',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
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

                            Navigator.pushNamed(context, RecipeView.routeName);
                          },
                          trailing: percentageShopping + percentageOwned >= 1
                              ? IconButton(
                                  onPressed: () {
                                    const snackBar = SnackBar(
                                      content: Text(
                                          'All of the ingredients are already either in your pantry or shopping list.'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: const Icon(Icons.check),
                                )
                              : IconButton(
                                  onPressed: () {
                                    const title = 'Add To Shopping List';
                                    const widget = Text(
                                        'Do you want to add the '
                                        'missing ingredients to your shopping list?');

                                    _showMyDialog(
                                        context, title, widget, ref, recipe);
                                  },
                                  icon: Icon(
                                    Icons.shopping_basket,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
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
