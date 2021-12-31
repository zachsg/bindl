import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/models/xmodels.dart';
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
          var sp = ref.read(shoppingListProvider);

          await up.setAllergy(
            allergy: key,
            isAllergic: selected,
            shouldPersist: shouldPersist,
          );

          await mp.loadMealsForIDs(up.recipes);

          await sp.clearPantry();
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
