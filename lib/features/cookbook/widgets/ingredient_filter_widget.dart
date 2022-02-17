import 'package:bodai/features/cookbook/controllers/ingredients_search_controller.dart';
import 'package:bodai/features/cookbook/controllers/sort_order_controller.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class IngredientFilterWidget extends ConsumerStatefulWidget {
  const IngredientFilterWidget({Key? key}) : super(key: key);

  @override
  _IngredientFilterWidget createState() => _IngredientFilterWidget();
}

class _IngredientFilterWidget extends ConsumerState<IngredientFilterWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filtersWrap(),
            _ingredientSearchField(),
            _ingredientsWrap(),
          ],
        ),
      ),
    );
  }

  Center _filtersWrap() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 2, left: 4, right: 4),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Latest'),
              selected: ref.watch(sortOrderProvider) == SortOrder.latest,
              onSelected: (selected) {
                ref
                    .read(sortOrderProvider.notifier)
                    .sortMeals(SortOrder.latest);
              },
            ),
            ChoiceChip(
              label: const Text('Quick Bites'),
              selected: ref.watch(sortOrderProvider) == SortOrder.quickest,
              onSelected: (selected) {
                ref
                    .read(sortOrderProvider.notifier)
                    .sortMeals(SortOrder.quickest);
              },
            ),
            ChoiceChip(
              label: const Text('Fewer Ingredients'),
              selected: ref.watch(sortOrderProvider) == SortOrder.fewest,
              onSelected: (selected) {
                ref
                    .read(sortOrderProvider.notifier)
                    .sortMeals(SortOrder.fewest);
              },
            ),
          ],
        ),
      ),
    );
  }

  TypeAheadFormField<String> _ingredientSearchField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _textController,
        scrollPadding: const EdgeInsets.only(bottom: 200),
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          labelText: 'Filter by ingredients you want to use',
        ),
      ),
      suggestionsCallback: (pattern) {
        return Ingredients.getSuggestions(
          ref: ref,
          pattern: pattern,
          inCookbook: true,
        );
      },
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion));
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (ingredient) {
        _textController.clear();

        ref
            .read(ingredientsSearchProvider.notifier)
            .setIngredientToUse(ingredient);
      },
      validator: (value) {
        return value != null && value.isEmpty ? typeIngredientLabel : null;
      },
      onSaved: (value) {},
    );
  }

  Widget _ingredientsWrap() {
    List<Widget> chips = [];

    for (var ingredient in ref.watch(ingredientsSearchProvider)) {
      var chip = Chip(
        backgroundColor: Theme.of(context).colorScheme.primary,
        label: Text(ingredient),
        onDeleted: () {
          ref
              .read(ingredientsSearchProvider.notifier)
              .removeIngredientToUse(ingredient);
        },
      );
      chips.add(chip);
    }

    return Wrap(
      spacing: 12,
      children: chips,
    );
  }
}