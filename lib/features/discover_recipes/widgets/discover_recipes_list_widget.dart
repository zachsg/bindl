import 'package:bodai/features/discover_recipes/recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../discover_recipes_controller.dart';
import 'no_recipes_found_widget.dart';
import 'recipe_card_widget.dart';

class DiscoverRecipesListWidget extends HookConsumerWidget {
  const DiscoverRecipesListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future =
        useMemoized(ref.watch(discoverRecipesProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ref.watch(searchedRecipeProvider).isEmpty
            ? const NoRecipesFoundWidget()
            : ref.watch(addingIngredientsToPantryProvider)
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        crossAxisCount: 2,
                      ),
                      itemCount: ref.watch(searchedRecipeProvider).length,
                      itemBuilder: (BuildContext context, int index) {
                        final recipe = ref.watch(searchedRecipeProvider)[index];

                        return RecipeCardWidget(recipe: recipe);
                      },
                    ),
                  )
        : Center(
            child: Lottie.asset('assets/gifs/lottie-loading-utensils.json'),
          );
  }
}
