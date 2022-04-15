import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../my_recipes/edit_recipe_controller.dart';
import '../edit_recipe_view.dart';

class RecipeServingsWidget extends ConsumerWidget {
  const RecipeServingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'Servings',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          icon: const SizedBox(),
          underline: const SizedBox(),
          value: ref.watch(editRecipeProvider).servings,
          onChanged: (servings) {
            if (servings != null) {
              ref.read(editRecipeProvider.notifier).setServings(servings);
              ref.read(recipeNeedsSavingProvider.notifier).state = true;
            }
          },
          items: <int>[
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
          ].map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                '$value',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
