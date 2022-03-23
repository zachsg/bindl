import 'package:bodai/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../pantry_controller.dart';

class PantryIngredientRowWidget extends ConsumerWidget {
  const PantryIngredientRowWidget({
    Key? key,
    required this.pantryIngredient,
    required this.index,
  }) : super(key: key);

  final PantryIngredient pantryIngredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        ref.read(pantryProvider.notifier).removeIngredientAtIndex(index);
      },
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ListTile(
          dense: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pantryIngredient.ingredient.name.capitalize(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () async {
                  final expiresOn = DateTime.parse(pantryIngredient.expiresOn);
                  final today = DateTime.now();

                  bool isPast = expiresOn.isBefore(today);

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: isPast
                        ? DateTime.now()
                        : DateTime.parse(pantryIngredient.expiresOn),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    await ref
                        .read(pantryProvider.notifier)
                        .updateExprationDateForIngredient(
                            pantryIngredient, picked);
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'Exp: ',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      '${DateTime.parse(pantryIngredient.expiresOn).month}'
                      '/'
                      '${DateTime.parse(pantryIngredient.expiresOn).day}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Text(
            'Added on: '
            '${DateTime.parse(pantryIngredient.addedOn).month}'
            '/'
            '${DateTime.parse(pantryIngredient.addedOn).day}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
