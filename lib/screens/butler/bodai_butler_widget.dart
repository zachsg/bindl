import 'package:bodai/controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BodaiButlerWidget extends ConsumerWidget {
  const BodaiButlerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        MealCard(meal: ref.watch(bestMealProvider)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'dislikeFab',
              onPressed: () async {
                await _confirmRatingDialog(context, ref, Rating.dislike);
              },
              child: const Icon(
                Icons.not_interested,
                size: 30,
              ),
            ),
            const SizedBox(width: 64),
            FloatingActionButton(
              heroTag: 'likeFab',
              onPressed: () async {
                await _confirmRatingDialog(context, ref, Rating.like);
              },
              child: const Icon(
                Icons.favorite,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _confirmRatingDialog(
      BuildContext context, WidgetRef ref, Rating rating) async {
    var meal = ref
        .watch(mealsProvider.notifier)
        .mealForID(ref.read(bestMealProvider).id);

    var title = rating == Rating.like
        ? moreLikeThisHeadingLabel
        : lessLikeThisHeadingLabel;

    var message = rating == Rating.like
        ? '$moreLikeThisBodyPartOneLabel ${meal.name.toLowerCase()}$moreLikeThisBodyPartTwoLabel'
        : '$lessLikeThisBodyPartOneLabel ${meal.name.toLowerCase()} $lessLikeThisBodyPartTwoLabel';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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
              child: rating == Rating.like
                  ? const Text('Add To Cookbook')
                  : const Text('Away With It!'),
              onPressed: () async {
                await confirmDenyButler(context, ref, rating, meal);
              },
            ),
            rating == Rating.like
                ? TextButton(
                    child: const Text('Add & View Cookbook'),
                    onPressed: () async {
                      await confirmDenyButler(context, ref, rating, meal);
                      ref.read(bottomNavProvider.notifier).state = 1;
                    },
                  )
                : const SizedBox(),
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
}