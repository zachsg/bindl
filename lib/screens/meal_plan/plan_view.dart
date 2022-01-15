import 'package:bodai/controllers/providers.dart';
import 'package:bodai/controllers/xcontrollers.dart';
import 'package:bodai/screens/cookbook/ingredient_filter_widget.dart';
import 'package:bodai/screens/settings/settings_view.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meal_details_view.dart';
import 'shopping_list_widget.dart';
import 'tutorial_card_widget.dart';

class PlanView extends ConsumerWidget {
  const PlanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.shopping_basket),
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.90),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              context: context,
              builder: (BuildContext context2) {
                return const ShoppingListWidget();
              },
            );
          },
        ),
        title: const Text('$myLabel $planLabel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.face),
            tooltip: preferencesLabel,
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              child: TutorialCardWidget(),
            ),
            ref.watch(mealPlanProvider).all.isEmpty
                ? const SizedBox()
                : Expanded(
                    child: mealCardList(ref),
                  ),
          ],
        ),
      ),
    );
  }

  Widget mealCardList(WidgetRef ref) {
    var mp = ref.watch(mealPlanProvider);

    return ListView.builder(
      shrinkWrap: true,
      restorationId: 'sampleItemListView', // listview to restore position
      itemCount: mp.all.length,
      itemBuilder: (BuildContext context3, int index) {
        final meal = mp.all[index];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: GestureDetector(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                index == 0 ? const SizedBox(height: 8) : const SizedBox(),
                MealCard(meal: meal),
                comfortBox(index, ref),
              ],
            ),
            onTap: () {
              Navigator.restorablePushNamed(
                context3,
                MealDetailsView.routeName,
                arguments: meal.id,
              );
            },
          ),
        );
      },
    );
  }

  Widget comfortBox(int index, WidgetRef ref) {
    var isEnd = index == ref.watch(mealPlanProvider).all.length - 1;

    if (isEnd) {
      return const SizedBox(height: 8);
    } else {
      return const SizedBox();
    }
  }
}
