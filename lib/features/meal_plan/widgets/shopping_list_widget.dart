import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/utils/helpers.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared_models/xmodels.dart';
import '../controllers/pantry_controller.dart';
import '../controllers/shopping_list_controller.dart';

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
          _shoppingListHeader(context, ref),
          _shoppingListBody(ref),
        ],
      ),
    );
  }

  Padding _shoppingListHeader(BuildContext context2, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            shoppingListLabel,
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

  Expanded _shoppingListBody(WidgetRef ref) {
    var sp = ref.watch(shoppingListProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: ListView.builder(
          itemCount: sp.all.length,
          itemBuilder: (context, index) {
            String key = sp.all.keys.elementAt(index);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getCategoryAndIngredientTiles(context, key, ref),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _getCategoryAndIngredientTiles(
      BuildContext context, String key, WidgetRef ref) {
    List<Widget> list = [];

    var sp = ref.watch(shoppingListProvider);
    var pp = ref.watch(pantryProvider);

    // Add ingredient category heading (e.g. 'Vegetables')
    list.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
        child: Text(
          key,
          style: Theme.of(context).textTheme.headline2?.copyWith(
              color: Theme.of(context).dividerColor, letterSpacing: 2),
        ),
      ),
    );

    var ingredients = sp.all[key];

    // Add all ingredients in a given category
    if (ingredients != null) {
      for (var ingredient in ingredients) {
        var measurementFormatted =
            ingredient.measurement.name.replaceAll(itemLabel, '').trim();

        var isItem = ingredient.measurement.name.contains(itemLabel);

        var quantityWithServings =
            ingredient.quantity * ref.watch(userProvider).servings;

        var quantity = Helpers.isInteger(quantityWithServings)
            ? quantityWithServings.round()
            : quantityWithServings.ceil();

        var inPantry = false;
        var x = pp.firstWhere(
            (element) =>
                element.name.toLowerCase() == ingredient.name.toLowerCase(),
            orElse: () => Ingredient(
                name: '', quantity: 0.0, measurement: Measurement.cup));
        if (x.name.isNotEmpty) {
          inPantry = true;
        }

        list.add(
          CheckboxListTile(
            onChanged: (checked) async {
              if (checked != null) {
                if (checked) {
                  await ref.read(pantryProvider.notifier).add(ingredient);
                } else {
                  await ref.read(pantryProvider.notifier).remove(ingredient);
                }
              }
            },
            value: inPantry,
            shape: const CircleBorder(),
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            visualDensity: const VisualDensity(vertical: -2.0),
            title: Row(
              children: [
                Text(
                  ingredient.name.split(',').first.capitalize(),
                  style: inPantry
                      ? Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(decoration: TextDecoration.lineThrough)
                      : Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  ' ($quantity',
                  style: inPantry
                      ? Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(decoration: TextDecoration.lineThrough)
                      : Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  isItem ? '$measurementFormatted)' : ' $measurementFormatted)',
                  style: inPantry
                      ? Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(decoration: TextDecoration.lineThrough)
                      : Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        );
      }
    }

    list.add(Divider(
      color: Theme.of(context).dividerColor,
    ));

    return list;
  }
}
