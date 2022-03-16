import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/diet.dart';
import '../edit_recipe_controller.dart';

class RecipeDietWidget extends ConsumerWidget {
  const RecipeDietWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          '     Diet:',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 8),
        DropdownButton<Diet>(
          isDense: true,
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          icon: const SizedBox(),
          underline: const SizedBox(),
          value: ref.watch(editRecipeProvider).diet,
          onChanged: (diet) {
            if (diet != null) {
              ref.read(editRecipeProvider.notifier).setDiet(diet);
            }
          },
          items: <Diet>[
            Diet.keto,
            Diet.paleo,
            Diet.omnivore,
            Diet.vegetarian,
            Diet.vegan,
          ].map<DropdownMenuItem<Diet>>((Diet diet) {
            return DropdownMenuItem<Diet>(
              value: diet,
              child: Text(
                diet.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
