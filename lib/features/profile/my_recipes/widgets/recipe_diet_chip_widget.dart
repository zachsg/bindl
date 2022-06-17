import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/xmodels.dart';
import '../../../../providers/providers.dart';
import '../edit_recipe_controller.dart';

class RecipeDietChipWidget extends ConsumerWidget {
  const RecipeDietChipWidget({super.key, required this.diet});

  final Diet diet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dietName = diet.name;

    return FilterChip(
      label: Text(dietName),
      selected: ref.watch(editRecipeProvider).diets.contains(diet),
      onSelected: (selected) {
        ref.read(editRecipeProvider.notifier).setDiet(diet, selected);
        ref.read(recipeNeedsSavingProvider.notifier).state = true;
      },
    );
  }
}
