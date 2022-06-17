import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/allergy.dart';
import 'recipe_allergy_chip_widget.dart';

class RecipeAllergiesWidget extends ConsumerWidget {
  const RecipeAllergiesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Recipe allergies',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'select all that apply',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontStyle: FontStyle.italic),
          ),
          Wrap(
            spacing: 16,
            children: const [
              RecipeAllergyChipWidget(allergy: Allergy.wheat),
              RecipeAllergyChipWidget(allergy: Allergy.soy),
              RecipeAllergyChipWidget(allergy: Allergy.sesame),
              RecipeAllergyChipWidget(allergy: Allergy.dairy),
              RecipeAllergyChipWidget(allergy: Allergy.eggs),
              RecipeAllergyChipWidget(allergy: Allergy.peanuts),
              RecipeAllergyChipWidget(allergy: Allergy.treeNuts),
              RecipeAllergyChipWidget(allergy: Allergy.shellfish),
            ],
          ),
        ],
      ),
    );
  }
}
