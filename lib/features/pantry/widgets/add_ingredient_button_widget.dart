import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/providers.dart';
import '../pantry_controller.dart';
import '../pantry_view.dart';

class AddIngredientButtonWidget extends ConsumerWidget {
  const AddIngredientButtonWidget({super.key, required this.toBuy});

  final bool toBuy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final navigator = Navigator.of(context);

        final ingredient = ref.read(addIngredientProvider).copyWith(
            measurement: ref.read(ingredientMeasureProvider),
            quantity: ref.read(ingredientQuantityProvider));

        await ref.read(pantryProvider.notifier).addIngredient(
              ingredient: ingredient,
              toBuy: toBuy,
              buyTab: ref.watch(pantryTabIndexProvider) == 1,
            );

        ref.read(ingredientQuantityProvider.notifier).state = 0.0;

        if (!toBuy) {
          ref.read(expiresOnProvider.notifier).state = DateTime.now();
        }

        ref.read(canAddIngredientProvider.notifier).state = false;

        navigator.pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Text(toBuy ? 'Add To Shopping List' : 'Add To Pantry'),
      ),
    );
  }
}
