import 'package:bodai/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../../providers/providers.dart';
import '../../discover_recipes/discover_recipes_controller.dart';
import '../pantry_controller.dart';

class PantryIngredientRowWidget extends ConsumerWidget {
  const PantryIngredientRowWidget({
    super.key,
    required this.pantryIngredient,
    required this.index,
    required this.toBuy,
  });

  final PantryIngredient pantryIngredient;
  final int index;
  final bool toBuy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (toBuy) {
      return ShoppingIngredientListTileWidget(
          pantryIngredient: pantryIngredient, index: index);
    } else {
      return PantryIngredientListTileWidget(
          pantryIngredient: pantryIngredient, index: index);
    }
  }
}

class ShoppingIngredientListTileWidget extends ConsumerWidget {
  const ShoppingIngredientListTileWidget({
    super.key,
    required this.pantryIngredient,
    required this.index,
  });

  final PantryIngredient pantryIngredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredient = pantryIngredient.ingredient;

    return InkWell(
      onTap: () {
        ref.read(ingredientMeasureProvider.notifier).state =
            ingredient.measurement;
        ref.read(ingredientQuantityProvider.notifier).state =
            ingredient.quantity;

        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              title: Text('Update: ${ingredient.name.capitalize()}'),
              content: SingleChildScrollView(
                child: UpdateIngredientWidget(
                  ingredient: ingredient,
                  index: index,
                ),
              ),
            );
          },
        );
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          ref
              .read(pantryProvider.notifier)
              .removeIngredientWithId(pantryIngredient);

          ref.refresh(recipesFutureProvider);
        },
        background: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ListTile(
            dense: true,
            leading: IconButton(
              onPressed: () async {
                final snackBar = SnackBar(
                  content: Text(
                      'Moved ${pantryIngredient.ingredient.name} to your pantry.'),
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                await ref
                    .read(pantryProvider.notifier)
                    .buyIngredient(pantryIngredient);
              },
              icon: Icon(
                Icons.circle_outlined,
                size: 28,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            title: Text(
              pantryIngredient.ingredient.name.capitalize(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: pantryIngredient.ingredient.quantity > 0
                ? Text(
                    '${pantryIngredient.ingredient.quantity.toFractionString()}'
                    '${pantryIngredient.ingredient.measurement == IngredientMeasure.ingredient ? '' : ' ${pantryIngredient.ingredient.measurement.name}'.replaceAll('toTaste', 'to taste')}',
                    style: const TextStyle(fontSize: 14),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class PantryIngredientListTileWidget extends ConsumerWidget {
  const PantryIngredientListTileWidget({
    super.key,
    required this.pantryIngredient,
    required this.index,
  });

  final PantryIngredient pantryIngredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredient = pantryIngredient.ingredient;
    final measurement =
        ' ${ingredient.measurement.name} '.replaceAll('toTaste', 'to taste');
    var formattedQuantity = '${ingredient.quantity.toFractionString()}'
        '${ingredient.measurement == IngredientMeasure.ingredient ? ' ' : measurement}';

    return Column(
      children: [
        InkWell(
          onTap: () {
            ref.read(ingredientMeasureProvider.notifier).state =
                ingredient.measurement;
            ref.read(ingredientQuantityProvider.notifier).state =
                ingredient.quantity;

            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  title: Text('Update: ${ingredient.name.capitalize()}'),
                  content: SingleChildScrollView(
                    child: UpdateIngredientWidget(
                      ingredient: ingredient,
                      index: index,
                    ),
                  ),
                );
              },
            );
          },
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              ref
                  .read(pantryProvider.notifier)
                  .removeIngredientWithId(pantryIngredient);

              ref.refresh(recipesFutureProvider);
            },
            background: Container(
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: ListTile(
                dense: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pantryIngredient.ingredient.name.capitalize(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Expires: ',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final expiresOn =
                                    DateTime.parse(pantryIngredient.expiresOn);
                                final today = DateTime.now();

                                bool isPast = expiresOn.isBefore(today);

                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: isPast
                                      ? DateTime.now()
                                      : DateTime.parse(
                                          pantryIngredient.expiresOn),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );
                                if (picked != null) {
                                  await ref
                                      .read(pantryProvider.notifier)
                                      .updateExpirationDateForIngredient(
                                          pantryIngredient, picked);
                                }
                              },
                              child: Text(
                                DateTime.now().year <
                                        DateTime.parse(
                                                pantryIngredient.expiresOn)
                                            .year
                                    ? 'Next Year'
                                    : DateTime.parse(pantryIngredient.expiresOn)
                                                .year ==
                                            1969
                                        ? 'Not Set'
                                        : '${DateTime.parse(pantryIngredient.expiresOn).month.toMonth()}'
                                            ' ${DateTime.parse(pantryIngredient.expiresOn).day}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formattedQuantity),
                    Text(
                      'Added: '
                      '${DateTime.parse(pantryIngredient.addedOn).month.toMonth()}'
                      ' ${DateTime.parse(pantryIngredient.addedOn).day},'
                      ' ${DateTime.parse(pantryIngredient.addedOn).year}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ],
    );
  }
}

class UpdateIngredientWidget extends HookConsumerWidget {
  const UpdateIngredientWidget({
    super.key,
    required this.ingredient,
    required this.index,
  });

  final Ingredient ingredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantityController = useTextEditingController(
        text: ingredient.quantity == 0.0 ? '' : ingredient.quantity.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.87,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: UpdateIngredientQuantityTextFieldWidget(
                      quantityController: quantityController),
                ),
                const SizedBox(width: 4),
                const Flexible(
                  flex: 2,
                  child: UpdateIngredientMeasureDropdownButtonWidget(),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              ref.read(pantryProvider.notifier).updateIngredientQuantity(
                  ingredient.id,
                  ref.read(ingredientQuantityProvider),
                  ref.read(ingredientMeasureProvider));

              ref.read(ingredientQuantityProvider.notifier).state = 0.0;

              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.0),
              child: Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateIngredientQuantityTextFieldWidget extends ConsumerWidget {
  const UpdateIngredientQuantityTextFieldWidget({
    super.key,
    required TextEditingController quantityController,
  }) : _quantityController = quantityController;

  final TextEditingController _quantityController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: _quantityController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (quantity) => ref
          .read(ingredientQuantityProvider.notifier)
          .state = double.tryParse(quantity) ?? 0.0,
      decoration: const InputDecoration(
        labelText: 'Qty',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class UpdateIngredientMeasureDropdownButtonWidget extends ConsumerWidget {
  const UpdateIngredientMeasureDropdownButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<IngredientMeasure>(
      elevation: 4,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(20), border: OutlineInputBorder()),
      icon: const SizedBox.shrink(),
      iconSize: 0.0,
      value: ref.watch(ingredientMeasureProvider),
      onChanged: (measurement) {
        if (measurement != null) {
          ref.read(ingredientMeasureProvider.notifier).state = measurement;
        }
      },
      items: IngredientMeasure.values
          .where(
              (element) => element.name != 'toTaste' && element.name != 'pinch')
          .map((IngredientMeasure classType) {
        return DropdownMenuItem<IngredientMeasure>(
          value: classType,
          child: Text(
            classType.name,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
