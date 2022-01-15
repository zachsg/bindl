import 'package:bodai/controllers/providers.dart';
import 'package:bodai/screens/meal_plan/bodai_butler_widget.dart';
import 'package:bodai/screens/settings/settings_view.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredient_filter_widget.dart';
import 'meal_plan_details_view.dart';

class MealHistoryView extends ConsumerWidget {
  const MealHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$myLabel $cookbookLabel'),
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
        child: mealCardList(context, ref),
      ),
    );
  }

  Widget mealCardList(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      restorationId: 'sampleItemListView', // listview to restore position
      itemCount: ref.watch(mealHistoryProvider).all.length + 1,
      itemBuilder: (BuildContext context3, int index) {
        if (index == 0 && ref.watch(mealHistoryProvider).all.isEmpty) {
          return Column(
            children: [
              const IngredientFilterWidget(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _manageEmptyState(context, ref),
                ),
              )
            ],
          );
        } else if (index == 0) {
          return const IngredientFilterWidget();
        } else {
          final meal = ref.watch(mealHistoryProvider).all[index - 1];

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
                  MealPlanDetailsView.routeName,
                  arguments: meal.id,
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _manageEmptyState(BuildContext context, WidgetRef ref) {
    if (ref.watch(userProvider).ingredientsToUse.isNotEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              'No matches found in your cookbook.\nBut... your Butler searched the globe, and found this meal to be your best match. How\'d the butler do?',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).disabledColor),
            ),
          ),
          const BodaiButlerWidget(),
        ],
      );
    } else if (ref.watch(mealHistoryProvider).all.isEmpty &&
        ref.watch(userProvider).ingredientsToUse.isEmpty) {
      return Text(
        'Add meals recommended by Bodai Butler to your cookbook!',
        style: Theme.of(context).textTheme.headline4,
      );
    } else {
      return Text(
        'No meals found in your cookbook containing all of those ingredients',
        style: Theme.of(context).textTheme.headline4,
      );
    }
  }

  Widget comfortBox(int index, WidgetRef ref) {
    var isEnd = index == ref.watch(mealHistoryProvider).all.length;

    if (isEnd) {
      return const SizedBox(height: 16);
    } else {
      return const SizedBox();
    }
  }
}
