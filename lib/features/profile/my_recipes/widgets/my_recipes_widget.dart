import 'package:bodai/extensions.dart';
import 'package:bodai/features/profile/my_recipes/edit_recipe_view.dart';
import 'package:bodai/features/profile/my_recipes/my_recipes_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../edit_recipe_controller.dart';

class MyRecipesWidget extends HookConsumerWidget {
  const MyRecipesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(myRecipesProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ref.watch(myRecipesProvider).isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No recipes found.\nCreate your first one!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              )
            : ListView.builder(
                restorationId: 'myRecipesListView',
                itemCount: ref.watch(myRecipesProvider).length,
                itemBuilder: (BuildContext context, int index) {
                  final recipe = ref.watch(myRecipesProvider)[index];

                  var dietsFormatted = '';
                  for (final d in recipe.diets) {
                    dietsFormatted += '#${d.name.capitalize()} ';
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == ref.watch(myRecipesProvider).length - 1
                          ? 80.0
                          : 0.0,
                    ),
                    child: Column(
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
                              vertical: 6, horizontal: 8),
                          title: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                                child: recipe.imageUrl.isEmpty
                                    ? const SizedBox(
                                        width: 64,
                                        child: Icon(
                                          Icons.no_food,
                                          size: 28,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: recipe.imageUrl,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
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
                                        Text(
                                            '#${recipe.cuisine.name.capitalize()}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            ref.read(editRecipeProvider.notifier).setup(recipe);

                            context.pushNamed(EditRecipeView.routeName);
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
        : const Center(child: CircularProgressIndicator());
  }
}
