import 'package:bodai/controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              dietaryRestrictionsLabel,
              style: Theme.of(context).textTheme.headline2,
            ),
            const Text(selectAllLabel),
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
          var sp = ref.read(shoppingListProvider);
          var pp = ref.read(pantryProvider);

          await up.setAllergy(
            allergy: key,
            isAllergic: selected,
            shouldPersist: shouldPersist,
          );

          mp.loadMealsForIDs(ref.read(mealsProvider), up.recipes);

          await pp.clear();

          sp.buildUnifiedShoppingList(ref);
        },
      );

      chips.add(chip);
    });

    return chips;
  }

  String formatAllergy(Allergy allergy) {
    switch (allergy) {
      case Allergy.treeNuts:
        return treeNutsLabel;
      case Allergy.gluten:
        return wheatGlutenLabel;
      default:
        var allergyString = allergy.toString().replaceAll('Allergy.', '');
        var firstLetter = allergyString[0].toUpperCase();
        var endOfWord = allergyString.substring(1);

        return firstLetter + endOfWord;
    }
  }
}