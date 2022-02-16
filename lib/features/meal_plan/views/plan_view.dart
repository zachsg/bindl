import 'package:bodai/features/meal_plan/models/plan_item.dart';
import 'package:bodai/features/settings/settings_view.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/helpers.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared_models/xmodels.dart';
import '../controllers/meal_plan_controller.dart';
import '../controllers/pantry_controller.dart';
import '../widgets/shopping_list_widget.dart';
import '../widgets/tutorial_card_widget.dart';

final firstToLastSortedPlanProvider = StateProvider<List<PlanItem>>((ref) {
  var list = ref.watch(mealPlanProvider);

  list.sort(((a, b) {
    if (DateTime.parse(a.plannedFor).isBefore(DateTime.parse(b.plannedFor))) {
      return 0;
    } else {
      return 1;
    }
  }));

  return list;
});

class PlanView extends ConsumerStatefulWidget {
  const PlanView({Key? key}) : super(key: key);

  @override
  _PlanViewState createState() => _PlanViewState();
}

class _PlanViewState extends ConsumerState<PlanView> {
  @override
  Widget build(BuildContext context) {
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
        title: const Text('$myLabel Meal $planLabel'),
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
            const TutorialCardWidget(),
            ref.watch(mealPlanProvider).isEmpty
                ? const SizedBox()
                : Expanded(
                    child: _mealCardList(ref),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _mealCardList(WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      restorationId: 'sampleItemListView', // listview to restore position
      itemCount: ref.watch(firstToLastSortedPlanProvider).length,
      itemBuilder: (BuildContext context3, int index) {
        final planItem = ref.watch(firstToLastSortedPlanProvider)[index];

        return Dismissible(
          key: Key(planItem.mealID.toString()),
          background: Row(
            children: const [
              Spacer(),
              Icon(Icons.cancel),
              SizedBox(width: 8),
            ],
          ),
          onDismissed: (direction) async {
            var message = 'removed from your plan';

            var meal =
                ref.read(mealsProvider.notifier).mealForID(planItem.mealID);

            ref.read(mealPlanProvider.notifier).removeFromMealPlan(meal);

            final snackBar = SnackBar(
              content: Text('${meal.name} $message'),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            if (ref.read(mealPlanProvider).isEmpty) {
              ref.read(pantryProvider).clear();
              ref.read(bottomNavProvider.notifier).state = 1;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                index == 0 ? const SizedBox(height: 2) : const SizedBox(),
                _mealListItem(context3, planItem.mealID, ref, index),
                _comfortBox(index, ref),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mealListItem(BuildContext context, int id, WidgetRef ref, int index) {
    var meal = ref.read(mealsProvider.notifier).mealForID(id);

    var isPast = DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor)
        .compareTo(DateTime.now().subtract(const Duration(days: 1)));

    var weekDayNum =
        DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor).weekday;
    var monthNum =
        DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor).month;

    var day = DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor).day;
    var weekday = weekDayNum.toWeekday();
    var month = monthNum.toMonth();

    if (isPast < 0) {
      weekday = 'Overdue';
    } else if (DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor)
            .compareTo(DateTime.now()) <
        0) {
      weekday = 'Today';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        elevation: 2,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  MealDetailsView.routeName,
                  arguments: meal.id,
                );
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Image.network(
                        meal.imageURL,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 8, right: 4),
                        title: Text(
                          meal.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontSize: 18),
                        ),
                        subtitle: _cardFooter(context, meal, ref),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Theme.of(context).disabledColor.withOpacity(0.1),
              height: 1.0,
            ),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: isPast < 0
                      ? DateTime.now()
                      : DateTime.parse(
                          ref.read(mealPlanProvider)[index].plannedFor),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 7)),
                );
                if (picked != null) {
                  await ref
                      .read(mealPlanProvider.notifier)
                      .updateMealDateInPlan(meal, picked);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        isPast < 0
                            ? Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: Icon(
                                  Icons.warning,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            : const SizedBox(),
                        Text(
                          '$month $day ($weekday)',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardFooter(BuildContext context, Meal meal, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: [
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: Theme.of(context).indicatorColor.withOpacity(0.6),
              ),
              Text(
                '${meal.duration} $minLabel',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).indicatorColor.withOpacity(0.6)),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.kitchen_outlined,
                color: Theme.of(context).indicatorColor.withOpacity(0.6),
              ),
              Text(
                '${meal.ingredients.length} ${ingredientsLabel.toLowerCase()}',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).indicatorColor.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _comfortBox(int index, WidgetRef ref) {
    var isEnd = index == ref.watch(mealPlanProvider).length - 1;

    if (isEnd) {
      return const SizedBox(height: 16);
    } else {
      return const SizedBox();
    }
  }
}
