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

  List<Widget> _getCategoryAndIngrdientTiles(
      BuildContext context, String key, WidgetRef ref) {
    List<Widget> list = [];

    var sp = ref.watch(shoppingListProvider);
    var pp = ref.watch(pantryProvider);

    list.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Text(
        key,
        style: Theme.of(context)
            .textTheme
            .headline2
            ?.copyWith(color: Theme.of(context).dividerColor, letterSpacing: 2),
      ),
    ));

    var ingredients = sp.all[key];

    if (ingredients != null) {
      for (var ingredient in ingredients) {
        var measurementFormatted =
            ingredient.measurement.name.replaceAll('item', '').trim();

        var isItem = ingredient.measurement.name.contains('item');

        var quantityWithServings =
            ingredient.quantity * ref.watch(userProvider).servings;

        var quantity = isInteger(quantityWithServings)
            ? quantityWithServings.round()
            : quantityWithServings.ceil();

        list.add(CheckboxListTile(
          onChanged: (checked) async {
            if (checked != null) {
              if (checked) {
                await ref.read(pantryProvider).add(ingredient);
              } else {
                await ref.read(pantryProvider).remove(ingredient);
              }
            }
          },
          value: pp.contains(ingredient),
          shape: const CircleBorder(),
          activeColor: Theme.of(context).colorScheme.primary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          visualDensity: const VisualDensity(vertical: -2.0),
          title: Row(
            children: [
              Text(
                ingredient.name.split(',').first.capitalize(),
                style: pp.contains(ingredient)
                    ? Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(decoration: TextDecoration.lineThrough)
                    : Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                ' ($quantity',
                style: pp.contains(ingredient)
                    ? Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(decoration: TextDecoration.lineThrough)
                    : Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                isItem ? '$measurementFormatted)' : ' $measurementFormatted)',
                style: pp.contains(ingredient)
                    ? Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(decoration: TextDecoration.lineThrough)
                    : Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ));
      }
    }

    list.add(Divider(
      color: Theme.of(context).dividerColor,
    ));

    return list;
  }

  Expanded shoppingListBody(WidgetRef ref) {
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
              children: _getCategoryAndIngrdientTiles(context, key, ref),
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
