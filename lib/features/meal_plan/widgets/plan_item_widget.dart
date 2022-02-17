import 'package:bodai/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared_controllers/providers.dart';
import '../../../shared_widgets/xwidgets.dart';
import '../../../utils/strings.dart';
import '../controllers/meal_plan_controller.dart';

class PlanItemWidget extends ConsumerWidget {
  const PlanItemWidget({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var meal = ref
        .read(mealsProvider.notifier)
        .mealForID(ref.watch(mealPlanProvider)[index].mealID);

    var plannedForDay =
        DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor).day;
    var todayDay = DateTime.now().day;

    bool isPast = plannedForDay < todayDay;

    var weekDayNum =
        DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor).weekday;
    var monthNum =
        DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor).month;

    var day = DateTime.parse(ref.watch(mealPlanProvider)[index].plannedFor).day;
    var weekday = weekDayNum.toWeekday();
    var month = monthNum.toMonth();

    if (isPast) {
      weekday = 'Overdue';
    } else if (plannedForDay == todayDay) {
      weekday = 'Today';
    } else if (plannedForDay == todayDay + 1) {
      weekday = 'Tomorrow';
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
                        subtitle: _cardFooter(context, ref),
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
                  initialDate: isPast
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
                        isPast
                            ? Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: Icon(
                                  Icons.warning,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            : const SizedBox(),
                        Text(
                          '$weekday, $month $day',
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

  Widget _cardFooter(BuildContext context, WidgetRef ref) {
    var meal = ref
        .read(mealsProvider.notifier)
        .mealForID(ref.watch(mealPlanProvider)[index].mealID);
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
}
