import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/providers.dart';
import '../edit_recipe_controller.dart';

class RecipeCookTimeWidget extends ConsumerWidget {
  const RecipeCookTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'Cook time',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          icon: const SizedBox(),
          underline: const SizedBox(),
          value: ref.watch(editRecipeProvider).cookTime,
          onChanged: (duration) {
            if (duration != null) {
              ref.read(editRecipeProvider.notifier).setCookTime(duration);
              ref.read(recipeNeedsSavingProvider.notifier).state = true;
            }
          },
          items: <int>[
            5,
            10,
            15,
            20,
            25,
            30,
            35,
            40,
            45,
            50,
            55,
            60,
            75,
            90,
            120,
            180,
          ].map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                '$value min',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
