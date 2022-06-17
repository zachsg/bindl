import 'package:bodai/features/profile/my_recipes/widgets/recipe_diet_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/diet.dart';

class RecipeDietWidget extends ConsumerWidget {
  const RecipeDietWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Recipe diets',
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
              RecipeDietChipWidget(diet: Diet.keto),
              RecipeDietChipWidget(diet: Diet.paleo),
              RecipeDietChipWidget(diet: Diet.omnivore),
              RecipeDietChipWidget(diet: Diet.vegetarian),
              RecipeDietChipWidget(diet: Diet.vegan),
            ],
          ),
        ],
      ),
    );
  }
}
