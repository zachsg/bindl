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
      mainAxisAlignment: MainAxisAlignment.center,
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
          actions: _alertDialogActions(context, ref, meal, rating),

          // <Widget>[
          //   rating == Rating.like
          //       ? TextButton(
          //           child: const Text('View In Cookbook'),
          //           onPressed: () async {
          //             await confirmDenyButler(context, ref, rating, meal);
          //             ref.read(bottomNavProvider.notifier).state = 1;
          //           },
          //         )
          //       : const SizedBox(),
          //   TextButton(
          //     child: rating == Rating.like
          //         ? const Text('Add & Continue')
          //         : const Text('Do Better, Butler!'),
          //     onPressed: () async {
          //       await confirmDenyButler(context, ref, rating, meal);
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  List<Widget> _alertDialogActions(
      BuildContext context, WidgetRef ref, Meal meal, Rating rating) {
    List<Widget> list = [];

    if (ref.read(bottomNavProvider.state).state == 1) {
      if (rating == Rating.like) {
        var widget = TextButton(
          child: const Text('Add To Cookbook'),
          onPressed: () async {
            await confirmDenyButler(context, ref, rating, meal);
            ref.read(bottomNavProvider.notifier).state = 1;
          },
        );

        list.add(widget);
      } else if (rating == Rating.dislike) {
        var widget = TextButton(
          child: const Text('Do Better, Butler!'),
          onPressed: () async {
            await confirmDenyButler(context, ref, rating, meal);
            ref.read(bottomNavProvider.notifier).state = 1;
          },
        );

        list.add(widget);
      }
    } else if (rating == Rating.like) {
      var widget = TextButton(
        child: const Text('View In Cookbook'),
        onPressed: () async {
          await confirmDenyButler(context, ref, rating, meal);
          ref.read(bottomNavProvider.notifier).state = 1;
        },
      );

      list.add(widget);
    }

    if (ref.read(bottomNavProvider.state).state == 0) {
      var widget = TextButton(
        child: rating == Rating.like
            ? const Text('Add & Continue')
            : const Text('Do Better, Butler!'),
        onPressed: () async {
          await confirmDenyButler(context, ref, rating, meal);
        },
      );

      list.add(widget);
    }

    return list;
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
