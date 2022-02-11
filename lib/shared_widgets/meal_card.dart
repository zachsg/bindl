import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:bodai/features/meal_plan/controllers/pantry_controller.dart';
import 'package:bodai/features/my_content/controllers/recipe_stats_controller.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isMealLoadingProvider = StateProvider<bool>((_) => false);

class MealCard extends ConsumerWidget {
  const MealCard({
    Key? key,
    required this.meal,
    this.isMyRecipe = false,
  }) : super(key: key);

  final Meal meal;
  final bool isMyRecipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          cardCover(context, ref, meal),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  cardFooter(context, meal, ref),
                  isMyRecipe
                      ? cardFooterForCreator(context, meal, ref)
                      : const SizedBox(),
                ],
              ),
              isMyRecipe
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextButton.icon(
                        label: Text(
                          meal.comments.length.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.70,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            context: context,
                            builder: (BuildContext context2) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          globalDiscussionLabel,
                                          style: Theme.of(context2)
                                              .textTheme
                                              .headline6,
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.cancel),
                                          onPressed: () =>
                                              Navigator.pop(context2),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: DiscussionWidget(meal: meal),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.insert_comment,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Container cardCover(BuildContext context, WidgetRef ref, Meal meal) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                meal.imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).shadowColor.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    meal.name,
                    style: Theme.of(context).textTheme.headline2,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          ref.watch(bottomNavProvider) == 1
              ? addToPlanButton(ref, meal, context)
              : ref.watch(bottomNavProvider) == 2 &&
                      ref.watch(mealPlanProvider).isNotEmpty
                  ? removeFromPlanButton(ref, meal, context)
                  : const SizedBox()
        ],
      ),
      constraints: const BoxConstraints.expand(
        width: 400,
        height: 300,
      ),
    );
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

  Positioned addToPlanButton(WidgetRef ref, Meal meal, BuildContext context) {
    return Positioned(
      right: -12,
      top: 6,
      child: RawMaterialButton(
        onPressed: () async {
          if (!ref.read(mealPlanProvider).contains(meal)) {
            await _confirmRatingDialog(context, ref, meal);
          } else {
            var message = 'is already in your plan';

            final snackBar = SnackBar(
              content: Text('${meal.name} $message'),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          Icons.add_circle,
          size: 38,
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.all(1.0),
        shape: const CircleBorder(),
      ),
    );
  }

  Positioned removeFromPlanButton(
      WidgetRef ref, Meal meal, BuildContext context) {
    return Positioned(
      right: -12,
      top: 6,
      child: RawMaterialButton(
        onPressed: () async {
          var message = 'removed from your plan';

          ref.read(mealPlanProvider.notifier).removeFromMealPlan(meal);

          final snackBar = SnackBar(
            content: Text('${meal.name} $message'),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          if (ref.read(mealPlanProvider).isEmpty) {
            ref.read(pantryProvider.notifier).clear();
            ref.read(bottomNavProvider.notifier).state = 1;
          }
        },
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          Icons.remove_circle,
          size: 38,
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.all(1.0),
        shape: const CircleBorder(),
      ),
    );
  }

  Padding cardFooter(BuildContext context, Meal meal, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 4),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
              ),
              Text(
                '${meal.duration} $minLabel',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              const Icon(
                Icons.kitchen_outlined,
              ),
              Text(
                '${meal.ingredients.length} ${ingredientsLabel.toLowerCase()}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding cardFooterForCreator(BuildContext context, Meal meal, WidgetRef ref) {
    var rp = ref.watch(recipeStatsProvider)[meal.id];

    return Padding(
      padding: const EdgeInsets.only(top: 2.0, left: 0.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.menu_book,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                ' In ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                rp?.numLikes == 1
                    ? '${rp?.inNumCookbooks ?? 0} cookbook'
                    : '${rp?.inNumCookbooks ?? 0} cookbooks',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                ' $cookedXTimesLabel ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                rp?.numLikes == 1
                    ? '${rp?.numLikes ?? 0} time'
                    : '${rp?.numLikes ?? 0} times',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.ballot_outlined,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                ' $currentlyInLabel ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                rp?.inNumOfPlans == 1
                    ? '${rp?.inNumOfPlans ?? 0} meal plan'
                    : '${rp?.inNumOfPlans ?? 0} meal plans',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
