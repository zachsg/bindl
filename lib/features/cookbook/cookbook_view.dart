import 'package:bodai/features/butler/bodai_butler_widget.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:bodai/features/settings/settings_view.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/cookbook_controller.dart';
import 'controllers/ingredients_search_controller.dart';
import 'ingredient_filter_widget.dart';

final mealsInMealPlanProvider = StateProvider<List<Meal>>((ref) {
  List<Meal> meals = [];

  var planItems = ref.watch(mealPlanProvider);
  for (var item in planItems) {
    var meal = ref.read(mealsProvider.notifier).mealForID(item.mealID);
    meals.add(meal);
  }

  return meals;
});

class CookbookView extends ConsumerWidget {
  const CookbookView({Key? key}) : super(key: key);

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
        child: ref.watch(userProvider).recipesLiked.isEmpty
            ? _emptyState(context, ref)
            : _mealCardList(context, ref),
      ),
    );
  }

  Column _emptyState(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Start by adding meals to your cookbook!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            ref.read(bottomNavProvider.notifier).state = 0;
          },
          child: const Text('Take Me To My Butler'),
        )
      ],
    );
  }

  Widget _mealCardList(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      restorationId: 'sampleItemListView', // listview to restore position
      itemCount: ref.watch(cookbookProvider).length + 1,
      itemBuilder: (BuildContext context2, int index) {
        if (index == 0 && ref.watch(cookbookProvider).isEmpty) {
          return Column(
            children: [
              const IngredientFilterWidget(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _manageEmptyState(context2, ref),
              ),
            ],
          );
        } else if (index == 0) {
          return const IngredientFilterWidget();
        } else {
          final meal = ref.watch(cookbookProvider)[index - 1];

          return InkWell(
            child: _mealListItem(context2, meal, ref),
            onTap: () {
              Navigator.restorablePushNamed(
                context2,
                MealDetailsView.routeName,
                arguments: meal.id,
              );
            },
          );
        }
      },
    );
  }

  Widget _mealListItem(BuildContext context, Meal meal, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        elevation: 2,
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
                          content: Text('${meal.name} is already in your plan'),
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
    );
  }

  Widget _manageEmptyState(BuildContext context, WidgetRef ref) {
    if (ref.watch(ingredientsSearchProvider).isNotEmpty) {
      if (ref.watch(bestMealProvider).id == -1) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
          child: Text(
            'Your Butler searched high and low but couldn\'t find the '
            'right meal. He\'s reported his failure to HQ.',
            style: Theme.of(context).textTheme.headline2,
          ),
        );
      } else {
        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
              child: Text(
                'No matches found in your cookbook.\nBut... your Butler '
                'searched the globe, and found this meal to be your best '
                'match. How\'d the butler do?',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).disabledColor),
              ),
            ),
            BodaiButlerWidget(parentRef: ref),
          ],
        );
      }
    } else if (ref.watch(cookbookProvider).isEmpty &&
        ref.watch(ingredientsSearchProvider).isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Start by adding meals to your cookbook!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavProvider.notifier).state = 0;
            },
            child: const Text('Take Me To My Butler'),
          )
        ],
      );
    } else {
      return Text(
        'No meals found in your cookbook containing all of those ingredients',
        style: Theme.of(context).textTheme.headline2,
      );
    }
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
