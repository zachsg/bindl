import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/cuisine.dart';
import '../../../../providers/providers.dart';
import '../../my_recipes/edit_recipe_controller.dart';

class RecipeCuisineWidget extends ConsumerWidget {
  const RecipeCuisineWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          'Cuisine:',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 8),
        DropdownButton<Cuisine>(
          isDense: true,
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          icon: const SizedBox(),
          underline: const SizedBox(),
          value: ref.watch(editRecipeProvider).cuisine,
          onChanged: (cuisine) {
            if (cuisine != null) {
              ref.read(editRecipeProvider.notifier).setCuisine(cuisine);
              ref.read(recipeNeedsSavingProvider.notifier).state = true;
            }
          },
          items: <Cuisine>[
            Cuisine.american,
            Cuisine.mexican,
            Cuisine.spanish,
            Cuisine.japanese,
            Cuisine.thai,
            Cuisine.chinese,
            Cuisine.korean,
            Cuisine.german,
            Cuisine.italian,
            Cuisine.french,
            Cuisine.indian,
            Cuisine.caribbean,
          ].map<DropdownMenuItem<Cuisine>>((Cuisine cuisine) {
            return DropdownMenuItem<Cuisine>(
              value: cuisine,
              child: Text(
                cuisine.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
