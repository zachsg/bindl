import 'package:bodai/features/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/xmodels.dart';
import '../../providers/providers.dart';
import 'pantry_controller.dart';
import 'widgets/add_ingredient_text_field_widget.dart';
import 'widgets/pantry_ingredient_row_widget.dart';
import 'widgets/pantry_tab_list_widget.dart';
import 'widgets/shopping_tab_list_widget.dart';

final addIngredientProvider = StateProvider<Ingredient>((ref) =>
    const Ingredient(id: -1, name: '', category: IngredientCategory.misc));
final expiresOnProvider = StateProvider<DateTime>((ref) => DateTime.now());
final loadingNewIngredientProvider = StateProvider<bool>((ref) => false);
final canAddIngredientProvider = StateProvider<bool>((ref) => false);

class PantryView extends ConsumerWidget {
  const PantryView({super.key});

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
                  child: Row(
                    children: [
                      Expanded(
                        child: TabBar(
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          labelColor: Theme.of(context).colorScheme.primary,
                          onTap: (index) => ref
                              .read(pantryTabIndexProvider.notifier)
                              .state = index,
                          tabs: <Widget>[
                            Tab(
                              text: 'Pantry & Fridge',
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.kitchen),
                                  const SizedBox(width: 6),
                                  Text(ref
                                      .watch(fridgeProvider)
                                      .length
                                      .toString()),
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
                                  Text(ref
                                      .watch(shoppingProvider)
                                      .length
                                      .toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ref
                            .read(sortAlphabeticallyProvider.notifier)
                            .state = !ref.watch(sortAlphabeticallyProvider),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.sort,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              ref.watch(sortAlphabeticallyProvider)
                                  ? Icon(
                                      Icons.abc,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : Icon(
                                      Icons.schedule,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                            ],
                          ),
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
  const PantryModalWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantityController = useTextEditingController();

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
                        quantityController: quantityController),
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: Row(
            //     children: [
            //       const Spacer(),
            //       Text(
            //         'Expires: ',
            //         style: Theme.of(context).textTheme.bodyLarge,
            //       ),
            //       OutlinedButton(
            //         onPressed: () async {
            //           final picked = await showDatePicker(
            //             context: context,
            //             initialDate: ref.read(expiresOnProvider),
            //             firstDate: ref.read(expiresOnProvider),
            //             lastDate: DateTime.now().add(const Duration(days: 365)),
            //           );
            //           if (picked != null) {
            //             ref.read(expiresOnProvider.notifier).state = picked;
            //           }
            //         },
            //         child:
            //             Text('${ref.watch(expiresOnProvider).month.toMonth()} '
            //                 '${ref.watch(expiresOnProvider).day}, '
            //                 '${ref.watch(expiresOnProvider).year}'),
            //       ),
            //       const Spacer(),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16),
            ref.watch(loadingNewIngredientProvider)
                ? const CircularProgressIndicator()
                : ref.watch(canAddIngredientProvider)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);

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

                              await ref
                                  .read(pantryProvider.notifier)
                                  .addIngredient(
                                    ingredient: ingredient,
                                    toBuy: false,
                                    buyTab:
                                        ref.watch(pantryTabIndexProvider) == 1,
                                  );

                              ref
                                  .read(ingredientQuantityProvider.notifier)
                                  .state = 0.0;

                              ref.read(expiresOnProvider.notifier).state =
                                  DateTime.now();

                              ref
                                  .read(loadingNewIngredientProvider.notifier)
                                  .state = false;

                              ref
                                  .read(canAddIngredientProvider.notifier)
                                  .state = false;

                              navigator.pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.0),
                              child: Text('Add To Pantry'),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ShoppingListModalWidget extends HookConsumerWidget {
  const ShoppingListModalWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantityController = useTextEditingController();

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
                        quantityController: quantityController),
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
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);

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

                              await ref
                                  .read(pantryProvider.notifier)
                                  .addIngredient(
                                    ingredient: ingredient,
                                    toBuy: true,
                                    buyTab:
                                        ref.watch(pantryTabIndexProvider) == 1,
                                  );

                              ref
                                  .read(ingredientQuantityProvider.notifier)
                                  .state = 0.0;

                              ref
                                  .read(loadingNewIngredientProvider.notifier)
                                  .state = false;

                              ref
                                  .read(canAddIngredientProvider.notifier)
                                  .state = false;

                              navigator.pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.0),
                              child: Text('Add To Shopping List'),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
