import 'package:bodai/extensions.dart';
import 'package:bodai/features/discover_recipes/recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/recipe.dart';
import '../../../models/xmodels.dart';
import '../../pantry/pantry_controller.dart';
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
          : ListView.builder(
              restorationId: 'discoverRecipesList',
              itemCount: recipes.length,
              itemBuilder: (BuildContext context, int index) {
                final recipe = recipes[index];
                final mutualIngredients = ref
                    .read(recipeProvider.notifier)
                    .crossReferencedRecipeIngredientsWithPantry(recipe);

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
                      title: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            child: Image.network(
                              recipe.imageUrl,
                              fit: BoxFit.cover,
                              height: 64,
                              width: 64,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                        '${recipe.prepTime + recipe.cookTime} min'),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.restaurant, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                        '${recipe.ingredients.length} ingredients'),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text('#${recipe.diet.name.capitalize()}'),
                                  const SizedBox(width: 16),
                                  Text('#${recipe.cuisine.name.capitalize()}'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: mutualIngredients.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                'Uses your: $mutualIngredients',
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                            )
                          : const SizedBox(),
                      onTap: () {
                        final List<Ingredient> ownedIngredients = [];

                        final List<String> pantryStrings = [];
                        for (final i in ref.read(pantryProvider)) {
                          pantryStrings.add(i.ingredient.name);
                        }

                        for (final i in recipe.ingredients) {
                          if (pantryStrings.contains(i.name)) {
                            ownedIngredients.add(i);
                          }
                        }

                        if (ownedIngredients.length ==
                            recipe.ingredients.length) {
                          ref.read(ownsAllIngredientsProvider.notifier).state =
                              true;
                        } else {
                          ref.read(ownsAllIngredientsProvider.notifier).state =
                              false;
                        }

                        ref
                            .read(recipeProvider.notifier)
                            .setupSelf(recipes[index].id!);

                        Navigator.pushNamed(context, RecipeView.routeName);
                      },
                    ),
                  ],
                );
              },
            ),
      error: (e, st) => const Center(child: Text('Error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}