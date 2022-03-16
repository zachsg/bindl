import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../edit_recipe_controller.dart';

class RecipePrepTimeWidget extends ConsumerWidget {
  const RecipePrepTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'Prep time',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          icon: const SizedBox(),
          underline: const SizedBox(),
          value: ref.watch(editRecipeProvider).prepTime,
          onChanged: (duration) {
            if (duration != null) {
              ref.read(editRecipeProvider.notifier).setPrepTime(duration);
            }
          },
          items: <int>[
            0,
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
