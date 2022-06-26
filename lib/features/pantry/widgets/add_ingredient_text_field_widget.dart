import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/ingredients.dart';
import '../pantry_view.dart';

class AddIngredientTextFieldWidget extends HookConsumerWidget {
  const AddIngredientTextFieldWidget({
    super.key,
    required this.title,
    required this.toBuy,
  });

  final String title;
  final bool toBuy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        scrollPadding: const EdgeInsets.only(bottom: 300),
        maxLines: 2,
        minLines: 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(title),
        ),
        onChanged: (text) {
          ref.read(canAddIngredientProvider.notifier).state = false;
        },
      ),
      suggestionsCallback: (pattern) {
        return Ingredients.getSuggestions(pattern, ref);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion as String));
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) async {
        controller.text = suggestion as String;
        ref.read(canAddIngredientProvider.notifier).state = true;
        final ingredient = Ingredients.all.firstWhere(
            (ingredient) => ingredient.name == suggestion.toLowerCase());

        ref.read(addIngredientProvider.notifier).state = ingredient;
      },
    );
  }
}
