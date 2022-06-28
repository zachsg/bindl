import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pantry_view.dart';
import 'add_ingredient_button_widget.dart';
import 'add_ingredient_text_field_widget.dart';
import 'pantry_ingredient_row_widget.dart';

class PantryModalWidget extends HookConsumerWidget {
  const PantryModalWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantityController = useTextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: 90,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add ingredient to pantry',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: UpdateIngredientQuantityTextFieldWidget(
                        quantityController: quantityController),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    flex: 4,
                    child: UpdateIngredientMeasureDropdownButtonWidget(),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    flex: 5,
                    child: AddIngredientTextFieldWidget(
                      title: 'Type ingredient',
                      toBuy: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ref.watch(canAddIngredientProvider)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      AddIngredientButtonWidget(toBuy: false),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
