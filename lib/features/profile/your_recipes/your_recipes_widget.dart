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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(recipeProvider.notifier)
                        .setupSelf(ref.read(yourRecipesProvider)[index].id!);

                    Navigator.pushNamed(context, RecipeView.routeName);
                  },
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(ref.watch(yourRecipesProvider)[index].name),
                  )),
                ),
              );
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
