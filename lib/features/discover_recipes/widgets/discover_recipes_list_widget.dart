import 'package:bodai/features/discover_recipes/recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/recipe.dart';
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
        data: (recipes) => ListView.builder(
              restorationId:
                  'sampleItemListView', // listview to restore position
              itemCount: recipes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(recipes[index].name),
                  onTap: () {
                    ref
                        .read(recipeProvider.notifier)
                        .setupSelf(recipes[index].id!);

                    Navigator.pushNamed(context, RecipeView.routeName);
                  },
                );
              },
            ),
        error: (e, st) => const Center(child: Text('Error')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
