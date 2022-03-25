import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/allergy.dart';
import '../../my_recipes/edit_recipe_controller.dart';

class RecipeAllergyChipWidget extends ConsumerWidget {
  const RecipeAllergyChipWidget({Key? key, required this.allergy})
      : super(key: key);

  final Allergy allergy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allergyName = allergy.name;
    if (allergy == Allergy.treeNuts) {
      allergyName = 'tree nuts';
    }

    return FilterChip(
      label: Text(allergyName),
      selected: ref.watch(editRecipeProvider).allergies.contains(allergy),
      onSelected: (selected) {
        ref.read(editRecipeProvider.notifier).setAllergy(allergy, selected);
      },
    );
  }
}
