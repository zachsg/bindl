import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingList extends ConsumerWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        shoppingListHeader(context),
        shoppingListBody(ref),
      ],
    );
  }

  Expanded shoppingListBody(WidgetRef ref) {
    var sp = ref.watch(shoppingListProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                ? quantityWithServings.ceil()
                : double.parse(quantityWithServings.toStringAsFixed(2))
                    .toFractionString();

            return Row(
              children: [
                Text(
                  ingredient.name.split(',').first.capitalize(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  ' ($quantity',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  isItem ? '$measurementFormatted)' : ' $measurementFormatted)',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
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
