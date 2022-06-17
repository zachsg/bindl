import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/recipe_type.dart';
import '../../../../providers/providers.dart';
import '../edit_recipe_controller.dart';

class RecipeRecipeTypeWidget extends ConsumerWidget {
  const RecipeRecipeTypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          '    Type:',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 8),
        DropdownButton<RecipeType>(
          // isDense: true,
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          icon: const SizedBox(),
          underline: const SizedBox(),
          value: ref.watch(editRecipeProvider).recipeType,
          onChanged: (recipeType) {
            if (recipeType != null) {
              ref.read(editRecipeProvider.notifier).setRecipeType(recipeType);
              ref.read(recipeNeedsSavingProvider.notifier).state = true;
            }
          },
          items: <RecipeType>[
            RecipeType.breakfast,
            RecipeType.lunch,
            RecipeType.dinner,
            RecipeType.appetizer,
            RecipeType.drink,
            RecipeType.soup,
            RecipeType.sandwich,
          ].map<DropdownMenuItem<RecipeType>>((RecipeType recipeType) {
            return DropdownMenuItem<RecipeType>(
              value: recipeType,
              child: Text(
                recipeType.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
