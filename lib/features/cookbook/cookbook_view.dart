import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/features/butler/bodai_butler_widget.dart';
import 'package:bodai/features/meal_plan/meal_plan_controller.dart';
import 'package:bodai/features/settings/settings_view.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cookbook_controller.dart';
import 'ingredient_filter_widget.dart';

final myCookbookIsCollapsedProvider = StateProvider<bool>((_) => false);

class CookbookView extends ConsumerWidget {
  const CookbookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$myLabel $cookbookLabel'),
        leading: IconButton(
          icon: ref.watch(myCookbookIsCollapsedProvider)
              ? const Icon(Icons.unfold_more)
              : const Icon(Icons.unfold_less),
          onPressed: () async {
            if (ref.read(myCookbookIsCollapsedProvider)) {
              await FirebaseAnalytics.instance
                  .logEvent(name: 'Collapsed cookbook view');
            } else {
              await FirebaseAnalytics.instance
                  .logEvent(name: 'Expanded cookbook view');
            }

            ref.read(myCookbookIsCollapsedProvider.notifier).state =
                !ref.read(myCookbookIsCollapsedProvider);
          },
        ),
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
        Text('Start by adding meals to your cookbook!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2),
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
      itemCount: ref.watch(cookbookProvider).all.length + 1,
      itemBuilder: (BuildContext context3, int index) {
        if (index == 0 && ref.watch(cookbookProvider).all.isEmpty) {
          return Column(
            children: [
              const IngredientFilterWidget(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _manageEmptyState(context, ref),
              ),
            ],
          );
        } else if (index == 0) {
          return const IngredientFilterWidget();
        } else {
          final meal = ref.watch(cookbookProvider).all[index - 1];

          return GestureDetector(
            child: ref.watch(myCookbookIsCollapsedProvider)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 6.0,
                    ),
                    child: Material(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            meal.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: _cardFooter(context, meal, ref),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 32.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () async {
                              if (!ref
                                  .read(mealPlanProvider)
                                  .all
                                  .contains(meal)) {
                                await _confirmRatingDialog(context, ref, meal);
                              } else {
                                var message = 'is already in your plan';

                                final snackBar = SnackBar(
                                  content: Text('${meal.name} $message'),
                                );
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        index == 1
                            ? const SizedBox(height: 6)
                            : const SizedBox(),
                        MealCard(meal: meal),
                        _comfortBox(index, ref),
                      ],
                    ),
                  ),
            onTap: () {
              Navigator.restorablePushNamed(
                context3,
                MealDetailsView.routeName,
                arguments: meal.id,
              );
            },
          );
        }
      },
    );
  }

  Widget _manageEmptyState(BuildContext context, WidgetRef ref) {
    if (ref.watch(userProvider).ingredientsToUse.isNotEmpty) {
      if (ref.watch(bestMealProvider).id == -1) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
          child: Text(
              'Your Butler searched high and low but couldn\'t find the '
              'right meal. He\'s reported his failure to HQ.',
              style: Theme.of(context).textTheme.headline2),
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
    } else if (ref.watch(cookbookProvider).all.isEmpty &&
        ref.watch(userProvider).ingredientsToUse.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Start by adding meals to your cookbook!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2),
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

  Widget _comfortBox(int index, WidgetRef ref) {
    var isEnd = index == ref.watch(cookbookProvider).all.length;

    if (isEnd) {
      return const SizedBox(height: 16);
    } else {
      return const SizedBox();
    }
  }

  Widget _cardFooter(BuildContext context, Meal meal, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
          const SizedBox(width: 12),
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
          const SizedBox(width: 12),
          Row(children: [
            _getIconRatingForMeal(context, meal, ref),
          ]),
        ],
      ),
    );
  }

  Widget _getIconRatingForMeal(BuildContext context, Meal meal, WidgetRef ref) {
    var liked = ref.watch(userProvider).recipesLiked;
    var disliked = ref.watch(userProvider).recipesDisliked;

    if (liked.contains(meal.id)) {
      var likes = liked.where((id) => id == meal.id);

      return Row(
        children: [
          Icon(
            Icons.thumb_up_outlined,
            color: Theme.of(context).indicatorColor.withOpacity(0.6),
          ),
          Text(
            'x${likes.length}',
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: Theme.of(context).indicatorColor.withOpacity(0.6),
                ),
          ),
        ],
      );
    } else if (disliked.contains(meal.id)) {
      return Icon(
        Icons.thumb_down_outlined,
        color: Theme.of(context).dividerColor,
      );
    } else {
      return const SizedBox();
    }
  }

  Future<void> _confirmRatingDialog(
      BuildContext context, WidgetRef ref, Meal meal) async {
    var title = 'Add to Meal Plan';

    var message =
        'Your Butler wants to confirm you\'d like to add the ${meal.name} to your meal plan.';

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
                ref.read(userProvider).addMealToPlan(meal);
                Navigator.pop(context);
                ref.read(bottomNavProvider.notifier).state = 2;
              },
            ),
            TextButton(
              child: const Text('Make It So'),
              onPressed: () async {
                ref.read(userProvider).addMealToPlan(meal);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
