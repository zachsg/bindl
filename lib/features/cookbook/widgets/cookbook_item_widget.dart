import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared_controllers/providers.dart';
import '../../../shared_models/xmodels.dart';
import '../../../shared_widgets/xwidgets.dart';
import '../../../utils/strings.dart';
import '../../meal_plan/controllers/meal_plan_controller.dart';

final mealsInMealPlanProvider = StateProvider<List<Meal>>((ref) {
  List<Meal> meals = [];

  var planItems = ref.watch(mealPlanProvider);
  for (var item in planItems) {
    var meal = ref.read(mealsProvider.notifier).mealForID(item.mealID);
    meals.add(meal);
  }

  return meals;
});

class CookbookItemWidget extends ConsumerWidget {
  const CookbookItemWidget({Key? key, required this.meal}) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        elevation: 2,
        child: InkWell(
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
                    contentPadding: const EdgeInsets.only(left: 8, right: 4),
                    title: Text(
                      meal.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontSize: 18),
                    ),
                    subtitle: _cardFooter(context, meal, ref),
                    trailing: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        ref.watch(mealsInMealPlanProvider).contains(meal)
                            ? Icons.check
                            : Icons.add_circle,
                        size: 32.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        if (!ref
                            .read(mealPlanProvider.notifier)
                            .containsMeal(meal.id)) {
                          await _confirmRatingDialog(context, ref, meal);
                        } else {
                          final snackBar = SnackBar(
                            content:
                                Text('${meal.name} is already in your plan'),
                          );
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  Future<void> _confirmRatingDialog(
      BuildContext context, WidgetRef ref, Meal meal) async {
    var title = 'Add to Meal Plan';

    var message = 'Your Butler wants to confirm you\'d like to add the'
        ' ${meal.name} to your meal plan.';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(left: 24, top: 4.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              TextButton(
                child: const Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add It & Show My Plan'),
              onPressed: () async {
                ref.read(mealPlanProvider.notifier).addMealToPlan(meal);
                Navigator.pop(context);
                ref.read(bottomNavProvider.notifier).state = 2;
              },
            ),
            TextButton(
              child: const Text('Make It So'),
              onPressed: () async {
                ref.read(mealPlanProvider.notifier).addMealToPlan(meal);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
