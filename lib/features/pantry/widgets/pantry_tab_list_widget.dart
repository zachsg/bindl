import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pantry_controller.dart';
import 'pantry_ingredient_row_widget.dart';

class PantryTabListWidget extends ConsumerWidget {
  const PantryTabListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ref.watch(fridgeProvider).isEmpty
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Pantry empty!\nAdd your ingredients with the button below or peruse recipes.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  restorationId: 'pantryList',
                  itemCount: ref.watch(fridgeProvider).length,
                  itemBuilder: (BuildContext context, int index) {
                    final pantryIngredient = ref.watch(fridgeProvider)[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == ref.watch(fridgeProvider).length - 1
                            ? 80.0
                            : 0.0,
                      ),
                      child: PantryIngredientRowWidget(
                        pantryIngredient: pantryIngredient,
                        index: index,
                        toBuy: false,
                      ),
                    );
                  },
                ),
              )
      ],
    );
  }
}
