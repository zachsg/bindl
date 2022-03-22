import 'package:bodai/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/ingredients.dart';
import 'pantry_controller.dart';

class PantryView extends HookConsumerWidget {
  const PantryView({Key? key}) : super(key: key);

  static const routeName = '/pantry';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useTextEditingController();

    final future = useMemoized(ref.read(pantryProvider.notifier).load);
    final snapshot = useFuture(future);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _controller,
                  scrollPadding: const EdgeInsets.only(bottom: 300),
                  maxLines: 2,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add ingredient to pantry',
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return Ingredients.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion as String));
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) async {
                  _controller.text = suggestion as String;
                  final ingredient = Ingredients.all.firstWhere((ingredient) =>
                      ingredient.name == suggestion.toLowerCase());

                  ref.read(pantryProvider.notifier).addIngredient(ingredient);
                  _controller.clear();
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ingredient';
                  }
                },
                onSaved: (value) async {
                  if (value != null) {
                    _controller.text = value;
                  }
                },
              ),
            ),
            Expanded(
              child: snapshot.hasData
                  ? ref.watch(pantryProvider).isEmpty
                      ? const Center(
                          child: Text(
                            'Pantry empty',
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                      : ListView.builder(
                          restorationId:
                              'sampleItemListView', // listview to restore position
                          itemCount: ref.watch(pantryProvider).length,
                          itemBuilder: (BuildContext context, int index) {
                            final pantryIngredient =
                                ref.watch(pantryProvider)[index];

                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                ref
                                    .read(pantryProvider.notifier)
                                    .removeIngredientAtIndex(index);
                              },
                              background: Container(
                                color: Theme.of(context).colorScheme.primary,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(pantryIngredient.ingredient.name
                                          .capitalize()),
                                      GestureDetector(
                                        onTap: () async {
                                          final expiresOn = DateTime.parse(
                                              pantryIngredient.expiresOn);
                                          final today = DateTime.now();

                                          bool isPast =
                                              expiresOn.isBefore(today);

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
                                                .updateExprationDateForIngredient(
                                                    pantryIngredient, picked);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Exp: ',
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                            Text(
                                              '${DateTime.parse(pantryIngredient.expiresOn).month}'
                                              '/'
                                              '${DateTime.parse(pantryIngredient.expiresOn).day}',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text('Added on: '
                                      '${DateTime.parse(pantryIngredient.addedOn).month}'
                                      '/'
                                      '${DateTime.parse(pantryIngredient.addedOn).day}'),
                                ),
                              ),
                            );
                          },
                        )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
