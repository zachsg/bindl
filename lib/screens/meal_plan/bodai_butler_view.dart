import 'package:bodai/controllers/providers.dart';
import 'package:bodai/models/rating.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BodaiButlerView extends ConsumerWidget {
  const BodaiButlerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
        ),
      ),
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
          title: Text(title),
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
              child: const Text(nopeLabel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(yupLabel),
              onPressed: () async {
                if (rating == Rating.like || rating == Rating.dislike) {
                  await ref
                      .read(userProvider)
                      .setRating(meal.id, meal.tags, rating);

                  ref.read(mealPlanProvider).load();

                  if (rating == Rating.like) {
                    ref.read(mealHistoryProvider.notifier).add(meal);
                  }

                  ref.read(bestMealProvider.notifier).compute();

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
