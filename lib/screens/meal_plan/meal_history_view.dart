import 'package:bodai/controllers/providers.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredient_filter_widget.dart';
import 'meal_plan_details_view.dart';

class MealHistoryView extends ConsumerWidget {
  const MealHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return mealCardList(context, ref);
  }

  Widget mealCardList(BuildContext context, WidgetRef ref) {
    // if (ref.watch(mealHistoryProvider).all.isEmpty) {
    //   return Center(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Text(
    //         'No meals found in your cookbook containing every ingredient',
    //         style: Theme.of(context).textTheme.headline2,
    //       ),
    //     ),
    //   );
    // } else {
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
                  child: ref.watch(userProvider).ingredientsToUse.length == 1
                      ? Text(
                          'No meals found in your cookbook containing that ingredient',
                          style: Theme.of(context).textTheme.headline4,
                        )
                      : ref.watch(mealHistoryProvider).all.isEmpty &&
                              ref.watch(userProvider).ingredientsToUse.isEmpty
                          ? Text(
                              'Add meals recommended by Bodai Butler to your cookbook!',
                              style: Theme.of(context).textTheme.headline4,
                            )
                          : Text(
                              'No meals found in your cookbook containing all of those ingredients',
                              style: Theme.of(context).textTheme.headline4,
                            ),
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
    // }
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
