import 'package:bodai/controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextButton.icon(
                          label: Text(
                            meal.comments.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      ref.watch(userProvider).recipes.isNotEmpty
                  ? removeFromPlanButton(ref, meal, context)
                  : const SizedBox()
        ],
      ),
      constraints: const BoxConstraints.expand(
        width: 370,
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
              child: const Text('Make It So'),
              onPressed: () async {
                ref.read(userProvider).addMealToPlan(meal);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Add It & Show My Plan'),
              onPressed: () async {
                ref.read(userProvider).addMealToPlan(meal);
                Navigator.pop(context);
                ref.read(bottomNavProvider.notifier).state = 2;
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmDenyButler(
      BuildContext context, WidgetRef ref, Rating rating, Meal meal) async {
    if (rating == Rating.like || rating == Rating.dislike) {
      await ref.read(userProvider).setRating(meal.id, meal.tags, rating);

      ref.read(mealPlanProvider).load();

      if (rating == Rating.like) {
        ref.read(mealHistoryProvider).add(meal);
      }

      ref.read(bestMealProvider.notifier).compute();

      Navigator.of(context).pop();
    }
  }

  Positioned addToPlanButton(WidgetRef ref, Meal meal, BuildContext context) {
    return Positioned(
      right: -12,
      top: 6,
      child: RawMaterialButton(
        onPressed: () async {
          if (!ref.read(mealPlanProvider).all.contains(meal)) {
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

          ref.read(userProvider).removeFromMealPlan(meal);

          final snackBar = SnackBar(
            content: Text('${meal.name} $message'),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          ref.read(mealPlanProvider).load();

          if (ref.read(userProvider).recipes.isEmpty) {
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
          const SizedBox(width: 12),
          Row(children: [
            getIconRatingForMeal(context, meal, ref),
          ]),
        ],
      ),
    );
  }

  Padding cardFooterForCreator(BuildContext context, Meal meal, WidgetRef ref) {
    var rp = ref.watch(recipeProvider).allMyStats[meal.id];

    return Padding(
      padding: const EdgeInsets.only(top: 2.0, left: 6.0, bottom: 6.0),
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
                    ? '${rp?.inNumCookbooks ?? 0} user\'s cookbook'
                    : '${rp?.inNumCookbooks ?? 0} users\' cookbooks',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.timeline_outlined,
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
                Icons.done_outline_outlined,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                ' $currentlyInLabel ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                rp?.inNumOfPlans == 1
                    ? '${rp?.inNumOfPlans ?? 0} user\'s plan'
                    : '${rp?.inNumOfPlans ?? 0} users\' plans',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getIconRatingForMeal(BuildContext context, Meal meal, WidgetRef ref) {
    var liked = ref.watch(userProvider).recipesLiked;
    var disliked = ref.watch(userProvider).recipesDisliked;

    if (liked.contains(meal.id)) {
      var likes = liked.where((id) => id == meal.id);

      return Row(
        children: [
          Icon(
            Icons.thumb_up_outlined,
            color: Theme.of(context).dividerColor,
          ),
          Text(
            'x${likes.length}',
            style: Theme.of(context).textTheme.bodyText2,
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
}
