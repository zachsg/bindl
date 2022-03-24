import 'package:bodai/features/profile/my_recipes/edit_recipe_view.dart';
import 'package:bodai/features/profile/my_recipes/my_recipes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../edit_recipe_controller.dart';

class MyRecipesWidget extends HookConsumerWidget {
  const MyRecipesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(myRecipesProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ListView.builder(
            restorationId: 'myRecipesListView',
            itemCount: ref.watch(myRecipesProvider).length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(editRecipeProvider.notifier)
                        .setup(ref.read(myRecipesProvider)[index]);

                    Navigator.pushNamed(context, EditRecipeView.routeName);
                  },
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(ref.watch(myRecipesProvider)[index].name),
                  )),
                ),
              );
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
