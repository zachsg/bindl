import 'package:bodai/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../discover_recipes/widgets/discover_recipes_list_widget.dart';
import '../pantry_controller.dart';

final ingredientQuantityProvider = StateProvider<double>((ref) => 0.0);

final ingredientMeasureProvider =
    StateProvider<IngredientMeasure>((ref) => IngredientMeasure.oz);

class PantryIngredientRowWidget extends ConsumerWidget {
  const PantryIngredientRowWidget({
    Key? key,
    required this.pantryIngredient,
    required this.index,
    required this.toBuy,
  }) : super(key: key);

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
    Key? key,
    required this.pantryIngredient,
    required this.index,
  }) : super(key: key);

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
              title: const Text('Edit Ingredient'),
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
                await ref
                    .read(pantryProvider.notifier)
                    .buyIngredient(pantryIngredient);

                final snackBar = SnackBar(
                  content: Text(
                      'Moved ${pantryIngredient.ingredient.name} to your pantry.'),
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    Key? key,
    required this.pantryIngredient,
    required this.index,
  }) : super(key: key);

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
        Container(
          height: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
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
                  title: const Text('Edit Ingredient'),
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
                            OutlinedButton(
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
                                    ? 'Next year'
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
      ],
    );
  }
}

class UpdateIngredientWidget extends HookConsumerWidget {
  const UpdateIngredientWidget({
    Key? key,
    required this.ingredient,
    required this.index,
  }) : super(key: key);

  final Ingredient ingredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _quantityController = useTextEditingController(
        text: ingredient.quantity == 0.0 ? '' : ingredient.quantity.toString());

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.87,
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: UpdateIngredientQuantityTextFieldWidget(
                    quantityController: _quantityController),
              ),
              const SizedBox(width: 4),
              const UpdateIngredientMeasureDropdownButtonWidget(),
              const SizedBox(width: 4),
              Flexible(
                flex: 2,
                child: Text(ingredient.name.capitalize()),
              ),
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
    );
  }
}

class UpdateIngredientQuantityTextFieldWidget extends ConsumerWidget {
  const UpdateIngredientQuantityTextFieldWidget({
    Key? key,
    required TextEditingController quantityController,
  })  : _quantityController = quantityController,
        super(key: key);

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
  const UpdateIngredientMeasureDropdownButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton<IngredientMeasure>(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      icon: const SizedBox.shrink(),
      iconSize: 0.0,
      underline: const SizedBox(),
      value: ref.watch(ingredientMeasureProvider),
      onChanged: (measurement) {
        if (measurement != null) {
          ref.read(ingredientMeasureProvider.notifier).state = measurement;
        }
      },
      items: IngredientMeasure.values.map((IngredientMeasure classType) {
        return DropdownMenuItem<IngredientMeasure>(
          value: classType,
          child: Text(
            classType.name == 'toTaste' ? 'to taste' : classType.name,
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
