import 'package:bodai/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/other_user_controller.dart';
import '../../discover_recipes/recipe_controller.dart';
import '../../discover_recipes/recipe_view.dart';
import 'your_recipes_controller.dart';

class YourRecipesWidget extends HookConsumerWidget {
  const YourRecipesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(yourRecipesProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ref.watch(yourRecipesProvider).isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '${ref.watch(otherUserProvider).name} hasn\'t created any recipes yet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              )
            : ListView.builder(
                restorationId: 'yourRecipesListView',
                itemCount: ref.watch(yourRecipesProvider).length,
                itemBuilder: (BuildContext context, int index) {
                  //TODO: Replace with Recipe card probably for nicer UI
                  final recipe = ref.watch(yourRecipesProvider)[index];
                  final mutualIngredients = ref
                      .read(recipeProvider.notifier)
                      .crossReferencedRecipeIngredientsWithPantry(recipe);

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
                            vertical: 4, horizontal: 8),
                        title: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
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
                                      Text(
                                          '#${recipe.cuisine.name.capitalize()}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        subtitle: mutualIngredients.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Uses your: $mutualIngredients',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            : const SizedBox(),
                        onTap: () {
                          ref
                              .read(recipeProvider.notifier)
                              .setupSelf(recipe.id!);

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
