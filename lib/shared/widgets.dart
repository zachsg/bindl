import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'ingredients.dart';

class AllergyCard extends ConsumerStatefulWidget {
  const AllergyCard({Key? key, this.shouldPersist = false}) : super(key: key);

  final bool shouldPersist;

  @override
  _AllergyCardState createState() => _AllergyCardState();
}

class _AllergyCardState extends ConsumerState<AllergyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My dietary restrictions 🤢',
              style: Theme.of(context).textTheme.headline2,
            ),
            const Text('select all you avoid'),
            Wrap(
              spacing: 12,
              children: buildAllergyChips(widget.shouldPersist),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildAllergyChips(bool shouldPersist) {
    List<Widget> chips = [];

    ref.watch(userProvider).allergies.forEach((key, value) {
      var chip = FilterChip(
        label: Text(formatAllergy(key)),
        selected: ref.watch(userProvider).isAllergic(key),
        onSelected: (selected) async {
          var up = ref.read(userProvider);
          var mp = ref.read(mealPlanProvider);

          await up.setAllergy(
            allergy: key,
            isAllergic: selected,
            shouldPersist: shouldPersist,
          );

          await mp.loadMealsForIDs(up.recipes);

          ref.read(shoppingListProvider).buildUnifiedShoppingList();
        },
      );

      chips.add(chip);
    });

    return chips;
  }

  String formatAllergy(Allergy allergy) {
    switch (allergy) {
      case Allergy.treeNuts:
        return 'Tree Nuts';
      case Allergy.gluten:
        return 'Wheat/Gluten';
      default:
        var allergyString = allergy.toString().replaceAll('Allergy.', '');
        var firstLetter = allergyString[0].toUpperCase();
        var endOfWord = allergyString.substring(1);

        return firstLetter + endOfWord;
    }
  }
}

class AdoreIngredientsCard extends ConsumerStatefulWidget {
  const AdoreIngredientsCard({Key? key, this.shouldPersist = false})
      : super(key: key);

  final bool shouldPersist;

  @override
  _AdoreIngredientsCardState createState() => _AdoreIngredientsCardState();
}

class _AdoreIngredientsCardState extends ConsumerState<AdoreIngredientsCard> {
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
              'Ingredients I adore 😍',
              style: Theme.of(context).textTheme.headline2,
            ),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Type ingredient'),
              ),
              suggestionsCallback: (pattern) {
                return Ingredients.getSuggestions(ref, pattern, true);
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

                await up.setAdoreIngredient(
                  ingredient: suggestion as String,
                  shouldPersist: widget.shouldPersist,
                );
                _textController.clear();

                await mp.loadMealsForIDs(up.recipes);

                ref.read(shoppingListProvider).buildUnifiedShoppingList();
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Type ingredient';
                }
              },
              onSaved: (value) async {
                var up = ref.read(userProvider);
                var mp = ref.read(mealPlanProvider);

                if (value != null && value.isNotEmpty) {
                  _textController.clear();

                  await up.setAdoreIngredient(
                    ingredient: value,
                    shouldPersist: widget.shouldPersist,
                  );

                  await mp.loadMealsForIDs(up.recipes);

                  ref.read(shoppingListProvider).buildUnifiedShoppingList();
                }
              },
            ),
            Wrap(
              spacing: 12,
              children: buildAdoreChips(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildAdoreChips() {
    List<Widget> chips = [];

    for (var ingredient in ref.watch(userProvider).adoreIngredients) {
      var chip = Chip(
        backgroundColor: Theme.of(context).colorScheme.primary,
        label: Text(ingredient),
        onDeleted: () async {
          var up = ref.read(userProvider);
          var mp = ref.read(mealPlanProvider);

          await up.removeAdoreIngredient(
            ingredient: ingredient,
            shouldPersist: widget.shouldPersist,
          );

          await mp.loadMealsForIDs(up.recipes);

          ref.read(shoppingListProvider).buildUnifiedShoppingList();

          Ingredients.all.add(ingredient);
        },
      );
      chips.add(chip);
    }

    return chips;
  }
}

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
              'Ingredients I abhor 🤬',
              style: Theme.of(context).textTheme.headline2,
            ),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Type ingredient'),
              ),
              suggestionsCallback: (pattern) {
                return Ingredients.getSuggestions(ref, pattern, false);
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

                await up.setAbhorIngredient(
                  ingredient: suggestion as String,
                  shouldPersist: widget.shouldPersist,
                );

                _textController.clear();

                await mp.loadMealsForIDs(up.recipes);

                ref.read(shoppingListProvider).buildUnifiedShoppingList();
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Type ingredient';
                }
              },
              onSaved: (value) async {
                var up = ref.read(userProvider);
                var mp = ref.read(mealPlanProvider);

                if (value != null && value.isNotEmpty) {
                  _textController.clear();

                  await up.setAbhorIngredient(
                    ingredient: value,
                    shouldPersist: widget.shouldPersist,
                  );

                  await mp.loadMealsForIDs(up.recipes);

                  ref.read(shoppingListProvider).buildUnifiedShoppingList();
                }
              },
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

          await up.removeAbhorIngredient(
            ingredient: ingredient,
            shouldPersist: widget.shouldPersist,
          );

          await mp.loadMealsForIDs(up.recipes);

          ref.read(shoppingListProvider).buildUnifiedShoppingList();

          Ingredients.all.add(ingredient);
        },
      );
      chips.add(chip);
    }

    return chips;
  }
}
