import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class IngredientFilterWidget extends ConsumerStatefulWidget {
  const IngredientFilterWidget({Key? key}) : super(key: key);

  @override
  _AbhorIngredientsCardState createState() => _AbhorIngredientsCardState();
}

class _AbhorIngredientsCardState extends ConsumerState<IngredientFilterWidget> {
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
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 4.0,
                bottom: 2.0,
                left: 4.0,
                right: 4.0,
              ),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Latest'),
                    selected: ref.watch(userProvider).sortLatest,
                    onSelected: (selected) {
                      ref.read(userProvider).sortMeals(
                          latest: true, shortest: false, fewest: false);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Quick Bites'),
                    selected: ref.watch(userProvider).sortShortestCooktime,
                    onSelected: (selected) {
                      ref.read(userProvider).sortMeals(
                          latest: false, shortest: true, fewest: false);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Fewer Ingredients'),
                    selected: ref.watch(userProvider).sortFewerIngredients,
                    onSelected: (selected) {
                      ref.read(userProvider).sortMeals(
                          latest: false, shortest: false, fewest: true);
                    },
                  ),
                ],
              ),
            ),
            TypeAheadFormField(
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
                return ListTile(
                  title: Text(suggestion as String),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (ingredient) {
                _textController.clear();

                ref.read(userProvider).setIngredientToUse(ingredient as String);

                Ingredients.allSimpleComplete.remove(ingredient);

                ref.read(bestMealProvider.notifier).compute();
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return typeIngredientLabel;
                }
              },
              onSaved: (value) {},
            ),
            Wrap(
              spacing: 12,
              children: buildIngredientChips(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildIngredientChips() {
    List<Widget> chips = [];

    for (var ingredient in ref.watch(userProvider).ingredientsToUse) {
      var chip = Chip(
        backgroundColor: Theme.of(context).colorScheme.primary,
        label: Text(ingredient),
        onDeleted: () {
          ref.read(userProvider).removeIngredientToUse(ingredient);

          ref.read(bestMealProvider.notifier).compute();

          Ingredients.allSimpleComplete.add(ingredient);
        },
      );
      chips.add(chip);
    }

    return chips;
  }
}
