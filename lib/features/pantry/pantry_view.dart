import 'package:bodai/features/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/ingredients.dart';
import 'pantry_controller.dart';
import 'widgets/pantry_ingredient_row_widget.dart';

final didOnboardingProvider = StateProvider<bool>((ref) => true);

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
        child: ref.watch(didOnboardingProvider)
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
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
                        final ingredient = Ingredients.all.firstWhere(
                            (ingredient) =>
                                ingredient.name == suggestion.toLowerCase());

                        ref
                            .read(pantryProvider.notifier)
                            .addIngredient(ingredient);
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
                  snapshot.hasData
                      ? ref.watch(pantryProvider).isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Pantry empty!\nLog your ingredients above.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              restorationId: 'pantryViewList',
                              itemCount: ref.watch(pantryProvider).length,
                              itemBuilder: (BuildContext context, int index) {
                                final pantryIngredient =
                                    ref.watch(pantryProvider)[index];

                                return PantryIngredientRowWidget(
                                  pantryIngredient: pantryIngredient,
                                  index: index,
                                );
                              },
                            )
                      : const Center(child: CircularProgressIndicator()),
                ],
              )
            : const OnboardingView(),
      ),
    );
  }
}
