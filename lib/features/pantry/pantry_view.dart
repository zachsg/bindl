import 'package:bodai/features/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/ingredients.dart';
import 'pantry_controller.dart';
import 'widgets/pantry_ingredient_row_widget.dart';

final didOnboardingProvider = StateProvider<bool>((ref) => true);

final pantryTabIndexProvider = StateProvider<int>((ref) => 0);

class PantryView extends ConsumerWidget {
  const PantryView({Key? key}) : super(key: key);

  static const routeName = '/pantry';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: ref.watch(didOnboardingProvider)
            ? AppBar(
                title: Container(
                  color: Colors.white,
                  child: ref.watch(pantryTabIndexProvider) == 0
                      ? const AddIngredientTextFieldWidget(
                          title: 'Add ingredient to pantry',
                          toBuy: false,
                        )
                      : const AddIngredientTextFieldWidget(
                          title: 'Add ingredient to shopping list',
                          toBuy: true,
                        ),
                ),
                bottom: TabBar(
                  onTap: (index) =>
                      ref.read(pantryTabIndexProvider.notifier).state = index,
                  tabs: <Widget>[
                    Tab(
                      // text: 'Pantry / Fridge',
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
                      // text: 'Shopping List',
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
                          'Pantry empty!\nLog your ingredients above.',
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

                        return PantryIngredientRowWidget(
                          pantryIngredient: pantryIngredient,
                          index: index,
                          toBuy: false,
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
                          'Shopping list empty!\nAdd ingredients above.',
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

                        return PantryIngredientRowWidget(
                          pantryIngredient: pantryIngredient,
                          index: index,
                          toBuy: true,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            label: Text(title)),
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
        final ingredient = Ingredients.all.firstWhere(
            (ingredient) => ingredient.name == suggestion.toLowerCase());

        await ref.read(pantryProvider.notifier).addIngredient(
              ingredient: ingredient,
              toBuy: toBuy,
              buyTab: ref.watch(pantryTabIndexProvider) == 1,
            );
        _controller.clear();
      },
    );
  }
}
