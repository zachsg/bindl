import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingListWidget extends ConsumerWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4.0,
        right: 4.0,
        bottom: 16.0,
        left: 4.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          shoppingListHeader(context),
          shoppingListBody(ref),
        ],
      ),
    );
  }

  Expanded shoppingListBody(WidgetRef ref) {
    var sp = ref.watch(shoppingListProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: ListView.builder(
          itemCount: sp.all.length,
          itemBuilder: (context, index) {
            var ingredient = sp.all[index];

            var measurementFormatted =
                ingredient.measurement.name.replaceAll('item', '').trim();

            var isItem = ingredient.measurement.name.contains('item');

            var quantityWithServings =
                ingredient.quantity * ref.watch(userProvider).servings;

            var quantity = isInteger(quantityWithServings)
                ? quantityWithServings.round()
                : quantityWithServings.ceil();

            return CheckboxListTile(
              onChanged: (checked) async {
                if (checked != null) {
                  if (checked) {
                    await ref
                        .read(shoppingListProvider)
                        .addIngredientToPantry(ingredient);
                  } else {
                    await ref
                        .read(shoppingListProvider)
                        .removeIngredientFromPantry(ingredient);
                  }
                }
              },
              value: sp.pantryContains(ingredient),
              shape: const CircleBorder(),
              activeColor: Theme.of(context).colorScheme.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              visualDensity: const VisualDensity(vertical: -2.0),
              title: Row(
                children: [
                  Text(
                    ingredient.name.split(',').first.capitalize(),
                    style: sp.pantryContains(ingredient)
                        ? Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(decoration: TextDecoration.lineThrough)
                        : Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    ' ($quantity',
                    style: sp.pantryContains(ingredient)
                        ? Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(decoration: TextDecoration.lineThrough)
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    isItem
                        ? '$measurementFormatted)'
                        : ' $measurementFormatted)',
                    style: sp.pantryContains(ingredient)
                        ? Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(decoration: TextDecoration.lineThrough)
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Padding shoppingListHeader(BuildContext context2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Shopping List',
            style: Theme.of(context2).textTheme.headline6,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.pop(context2),
          ),
        ],
      ),
    );
  }
}
