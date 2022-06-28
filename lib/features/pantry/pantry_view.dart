import 'package:bodai/features/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/xmodels.dart';
import '../../providers/providers.dart';
import 'pantry_controller.dart';
import 'widgets/pantry_modal_widget.dart';
import 'widgets/pantry_sort_widget.dart';
import 'widgets/pantry_tab_list_widget.dart';
import 'widgets/shopping_list_modal_widget.dart';
import 'widgets/shopping_tab_list_widget.dart';

final addIngredientProvider = StateProvider<Ingredient>((ref) =>
    const Ingredient(id: -1, name: '', category: IngredientCategory.misc));
final expiresOnProvider = StateProvider<DateTime>((ref) => DateTime.now());
final canAddIngredientProvider = StateProvider<bool>((ref) => false);

class PantryView extends ConsumerWidget {
  const PantryView({super.key});

  static const routeName = '/pantry';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fridgeCount = ref.watch(fridgeProvider).length;
    final shoppingCount = ref.watch(shoppingProvider).length;

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
                                  Text('$fridgeCount'),
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
                                  Text('$shoppingCount'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PantrySortWidget()
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
