import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/providers.dart';
import '../edit_recipe_controller.dart';

class RecipeNameTextFieldWidget extends HookConsumerWidget {
  const RecipeNameTextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useTextEditingController(text: ref.watch(editRecipeProvider).name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          ref.read(editRecipeProvider.notifier).setName(text);
          ref.read(recipeNeedsSavingProvider.notifier).state = true;
        },
        decoration: const InputDecoration(
          labelText: 'Recipe Name',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
