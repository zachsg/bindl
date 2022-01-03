import 'package:bodai/controllers/xcontrollers.dart';
import 'package:bodai/widgets/xwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meal_plan_details_view.dart';

class MealPlanCurrentView extends ConsumerWidget {
  const MealPlanCurrentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                MealPlanDetailsView.routeName,
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
