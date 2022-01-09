import 'package:bodai/controllers/xcontrollers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AbhorIngredientsCard extends ConsumerStatefulWidget {
  const AbhorIngredientsCard({Key? key, this.shouldPersist = false})
      : super(key: key);

  final bool shouldPersist;

  @override
  _AbhorIngredientsCardState createState() => _AbhorIngredientsCardState();
}

class _AbhorIngredientsCardState extends ConsumerState<AbhorIngredientsCard> {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ingredientsAbhorLabel,
              style: Theme.of(context).textTheme.headline2,
            ),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _textController,
                decoration:
                    const InputDecoration(labelText: typeIngredientLabel),
              ),
              suggestionsCallback: (pattern) {
                return Ingredients.getSuggestions(ref: ref, pattern: pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion as String),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) async {
                var up = ref.read(userProvider);
                var mp = ref.read(mealPlanProvider);
                var sp = ref.read(shoppingListProvider);
                var pp = ref.read(pantryProvider);

                await up.setAbhorIngredient(
                  ingredient: suggestion as String,
                  isAbhor: true,
                  shouldPersist: widget.shouldPersist,
                );

                _textController.clear();

                mp.loadMealsForIDs(ref.read(mealsProvider), up.recipes);

                await pp.clear();

                sp.buildUnifiedShoppingList(ref);
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
              children: buildAbhorChips(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildAbhorChips() {
    List<Widget> chips = [];

    for (var ingredient in ref.watch(userProvider).abhorIngredients) {
      var chip = Chip(
        backgroundColor: Theme.of(context).colorScheme.primary,
        label: Text(ingredient),
        onDeleted: () async {
          var up = ref.read(userProvider);
          var mp = ref.read(mealPlanProvider);
          var sp = ref.read(shoppingListProvider);
          var pp = ref.read(pantryProvider);

          await up.setAbhorIngredient(
            ingredient: ingredient,
            isAbhor: false,
            shouldPersist: widget.shouldPersist,
          );

          mp.loadMealsForIDs(ref.read(mealsProvider), up.recipes);

          await pp.clear();

          sp.buildUnifiedShoppingList(ref);

          Ingredients.all.add(ingredient);
        },
      );
      chips.add(chip);
    }

    return chips;
  }
}
