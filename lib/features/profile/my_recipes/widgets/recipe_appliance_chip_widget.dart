import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/xmodels.dart';
import '../edit_recipe_controller.dart';

class RecipeApplianceChipWidget extends ConsumerWidget {
  const RecipeApplianceChipWidget({super.key, required this.appliance});

  final Appliance appliance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var applianceName = appliance.name;
    if (appliance == Appliance.airFryer) {
      applianceName = 'air fryer';
    } else if (appliance == Appliance.instantPot) {
      applianceName = 'instant pot';
    }

    return FilterChip(
      label: Text(applianceName),
      selected: ref.watch(editRecipeProvider).appliances.contains(appliance),
      onSelected: (selected) {
        ref.read(editRecipeProvider.notifier).setAppliance(appliance, selected);
        ref.read(recipeNeedsSavingProvider.notifier).state = true;
      },
    );
  }
}
