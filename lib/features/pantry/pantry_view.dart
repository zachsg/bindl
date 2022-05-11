import 'package:bodai/extensions.dart';
import 'package:bodai/features/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/ingredients.dart';
import '../../providers/providers.dart';
import 'pantry_controller.dart';
import 'widgets/pantry_ingredient_row_widget.dart';

class PantryView extends ConsumerWidget {
  const PantryView({Key? key}) : super(key: key);

  static const routeName = '/pantry';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      initialIndex: ref.watch(pantryTabIndexProvider),
      length: 2,
      child: Scaffold(
        appBar: ref.watch(didOnboardingProvider)
            ? AppBar(
                toolbarHeight: 64,
                flexibleSpace: SafeArea(
                  child: TabBar(
                    labelColor: Theme.of(context).colorScheme.primary,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    onTap: (index) =>
                        ref.read(pantryTabIndexProvider.notifier).state = index,
                    tabs: <Widget>[
                      Tab(
                        text: 'Pantry & Fridge',
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.kitchen),
                            const SizedBox(width: 6),
                            Text(ref.watch(fridgeProvider).length.toString()),
                          ],
                        ),
                      ),
                      Tab(
                        text: 'Shopping List',
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_basket_outlined),
                            const SizedBox(width: 6),
                            Text(ref.watch(shoppingProvider).length.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: SafeArea(
          child: ref.watch(didOnboardingProvider)
              ? const TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PantryTabListWidget(),
                    ShoppingTabListWidget(),
                  ],
                )
              : const OnboardingView(),
        ),
        floatingActionButton: ref.watch(didOnboardingProvider)
            ? FloatingActionButton(
                onPressed: () {
                  final isPantry = ref.read(pantryTabIndexProvider) == 0;

                  Widget widget = isPantry
                      ? const PantryModalWidget()
                      : const ShoppingListModalWidget();

                  ref.read(expiresOnProvider.notifier).state = DateTime.now();

                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                      ),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                        child: widget,
                        onTap: () =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

class PantryModalWidget extends HookConsumerWidget {
  const PantryModalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _quantityController = useTextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: 90,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add ingredient to pantry',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: UpdateIngredientQuantityTextFieldWidget(
                        quantityController: _quantityController),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    flex: 4,
                    child: UpdateIngredientMeasureDropdownButtonWidget(),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    flex: 5,
                    child: AddIngredientTextFieldWidget(
                      title: 'Type ingredient',
                      toBuy: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Expires: ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: ref.read(expiresOnProvider),
                        firstDate: ref.read(expiresOnProvider),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        ref.read(expiresOnProvider.notifier).state = picked;
                      }
                    },
                    child:
                        Text('${ref.watch(expiresOnProvider).month.toMonth()} '
                            '${ref.watch(expiresOnProvider).day}, '
                            '${ref.watch(expiresOnProvider).year}'),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ref.watch(loadingNewIngredientProvider)
                ? const CircularProgressIndicator()
                : ref.watch(canAddIngredientProvider)
                    ? ElevatedButton(
                        onPressed: () async {
                          final ingredient = ref
                              .read(addIngredientProvider)
                              .copyWith(
                                  measurement:
                                      ref.read(ingredientMeasureProvider),
                                  quantity:
                                      ref.read(ingredientQuantityProvider));

                          ref
                              .read(loadingNewIngredientProvider.notifier)
                              .state = true;

                          await ref.read(pantryProvider.notifier).addIngredient(
                                ingredient: ingredient,
                                toBuy: false,
                                buyTab: ref.watch(pantryTabIndexProvider) == 1,
                              );

                          ref.read(ingredientQuantityProvider.notifier).state =
                              0.0;

                          ref.read(expiresOnProvider.notifier).state =
                              DateTime.now();

                          ref
                              .read(loadingNewIngredientProvider.notifier)
                              .state = false;

                          ref.read(canAddIngredientProvider.notifier).state =
                              false;

                          Navigator.of(context).pop();
                        },
                        child: const Text('Add To Pantry'),
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ShoppingListModalWidget extends HookConsumerWidget {
  const ShoppingListModalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _quantityController = useTextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: 90,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add ingredient to shopping list',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: UpdateIngredientQuantityTextFieldWidget(
                        quantityController: _quantityController),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    flex: 4,
                    child: UpdateIngredientMeasureDropdownButtonWidget(),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    flex: 5,
                    child: AddIngredientTextFieldWidget(
                      title: 'Type ingredient',
                      toBuy: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ref.watch(loadingNewIngredientProvider)
                ? const CircularProgressIndicator()
                : ref.watch(canAddIngredientProvider)
                    ? ElevatedButton(
                        onPressed: () async {
                          final ingredient = ref
                              .read(addIngredientProvider)
                              .copyWith(
                                  measurement:
                                      ref.read(ingredientMeasureProvider),
                                  quantity:
                                      ref.read(ingredientQuantityProvider));

                          ref
                              .read(loadingNewIngredientProvider.notifier)
                              .state = true;

                          await ref.read(pantryProvider.notifier).addIngredient(
                                ingredient: ingredient,
                                toBuy: true,
                                buyTab: ref.watch(pantryTabIndexProvider) == 1,
                              );

                          ref.read(ingredientQuantityProvider.notifier).state =
                              0.0;
                          // ref.read(ingredientMeasureProvider.notifier).state =
                          //     IngredientMeasure.g;

                          ref
                              .read(loadingNewIngredientProvider.notifier)
                              .state = false;

                          ref.read(canAddIngredientProvider.notifier).state =
                              false;

                          Navigator.of(context).pop();
                        },
                        child: const Text('Add To Shopping List'),
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class PantryTabListWidget extends HookConsumerWidget {
  const PantryTabListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(pantryProvider.notifier).load);
    final snapshot = useFuture(future);

    return Column(
      children: [
        snapshot.hasData
            ? ref.watch(fridgeProvider).isEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Pantry empty!\nAdd your ingredients with the button below or peruse recipes.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      restorationId: 'pantryList',
                      itemCount: ref.watch(fridgeProvider).length,
                      itemBuilder: (BuildContext context, int index) {
                        final pantryIngredient =
                            ref.watch(fridgeProvider)[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                index == ref.watch(fridgeProvider).length - 1
                                    ? 80.0
                                    : 0.0,
                          ),
                          child: PantryIngredientRowWidget(
                            pantryIngredient: pantryIngredient,
                            index: index,
                            toBuy: false,
                          ),
                        );
                      },
                    ),
                  )
            : const Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
}

class ShoppingTabListWidget extends HookConsumerWidget {
  const ShoppingTabListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(pantryProvider.notifier).load);
    final snapshot = useFuture(future);

    return Column(
      children: [
        snapshot.hasData
            ? ref.watch(shoppingProvider).isEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Shopping list empty!\nAdd ingredients with the button below or peruse recipes.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      restorationId: 'shoppingList',
                      itemCount: ref.watch(shoppingProvider).length,
                      itemBuilder: (BuildContext context, int index) {
                        final pantryIngredient =
                            ref.watch(shoppingProvider)[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                index == ref.watch(shoppingProvider).length - 1
                                    ? 80.0
                                    : 0.0,
                          ),
                          child: PantryIngredientRowWidget(
                            pantryIngredient: pantryIngredient,
                            index: index,
                            toBuy: true,
                          ),
                        );
                      },
                    ),
                  )
            : const Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
}

class AddIngredientTextFieldWidget extends HookConsumerWidget {
  const AddIngredientTextFieldWidget({
    Key? key,
    required this.title,
    required this.toBuy,
  }) : super(key: key);

  final String title;
  final bool toBuy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useTextEditingController();

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _controller,
        scrollPadding: const EdgeInsets.only(bottom: 300),
        maxLines: 2,
        minLines: 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(title),
        ),
        onChanged: (text) {
          ref.read(canAddIngredientProvider.notifier).state = false;
        },
      ),
      suggestionsCallback: (pattern) {
        return Ingredients.getSuggestions(pattern, ref);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion as String));
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) async {
        _controller.text = suggestion as String;
        ref.read(canAddIngredientProvider.notifier).state = true;
        final ingredient = Ingredients.all.firstWhere(
            (ingredient) => ingredient.name == suggestion.toLowerCase());

        ref.read(addIngredientProvider.notifier).state = ingredient;
      },
    );
  }
}
