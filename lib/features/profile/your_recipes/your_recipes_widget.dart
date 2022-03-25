import 'package:bodai/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../discover_recipes/recipe_controller.dart';
import '../../discover_recipes/recipe_view.dart';
import 'your_recipes_controller.dart';

class YourRecipesWidget extends HookConsumerWidget {
  const YourRecipesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(yourRecipesProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ListView.builder(
            restorationId: 'yourRecipesListView',
            itemCount: ref.watch(yourRecipesProvider).length,
            itemBuilder: (BuildContext context, int index) {
              //TODO: Replace with Recipe card probably for nicer UI
              final recipe = ref.watch(yourRecipesProvider)[index];
              final mutualIngredients = ref
                  .read(recipeProvider.notifier)
                  .crossReferencedRecipeIngredientsWithPantry(recipe);

              return Column(
                children: [
                  Container(
                    height: 1,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              'Uses your: $mutualIngredients',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          )
                        : const SizedBox(),
                    onTap: () {
                      ref.read(recipeProvider.notifier).setupSelf(recipe.id!);

                      Navigator.pushNamed(context, RecipeView.routeName);
                    },
                  ),
                ],
              );
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
