import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consecutiveSwipesProvider = StateProvider<int>((_) => 0);
final swipeIsLikeProvider = StateProvider<bool>((_) => false);
final wasJustDismissedProvider = StateProvider<bool>((_) => false);
final isButlerLoadingProvider = StateProvider<bool>((_) => false);

class BodaiButlerWidget extends ConsumerWidget {
  const BodaiButlerWidget({Key? key, required this.parentRef})
      : super(key: key);

  final WidgetRef parentRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var meal = ref.watch(bestMealProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (ref.watch(isButlerLoadingProvider))
          const Center(child: ProgressSpinner())
        else if (ref.watch(bottomNavProvider) == 0)
          _dismissibleMealCard(ref, meal, context)
        else
          MealCard(meal: ref.watch(bestMealProvider)),
        const SizedBox(height: 16),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: ref.watch(wasJustDismissedProvider) ? 0.0 : 1.0,
          child: ref.watch(isButlerLoadingProvider)
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dislikeButton(ref, meal, context),
                    const SizedBox(width: 64),
                    _likeButton(ref, context, meal),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _dislikeButton(WidgetRef ref, Meal meal, BuildContext context) {
    return FloatingActionButton(
      heroTag: 'dislikeFab',
      onPressed: () async {
        ref.read(isButlerLoadingProvider.notifier).state = true;

        if (ref.read(bottomNavProvider) == 0) {
          await _dislikedIt(meal, ref);

          _showUndoSnackBar(
              context, ref, '${meal.name} is gone forever', meal, false);
        } else {
          _confirmRatingDialog(context, ref, Rating.dislike);
        }

        ref.read(isButlerLoadingProvider.notifier).state = false;
      },
      child: const Icon(
        Icons.not_interested,
        size: 30,
      ),
    );
  }

  Widget _likeButton(WidgetRef ref, BuildContext context, Meal meal) {
    return FloatingActionButton(
      heroTag: 'likeFab',
      onPressed: () async {
        ref.read(isButlerLoadingProvider.notifier).state = true;

        if (ref.read(bottomNavProvider) == 0) {
          await _likeIt(context, meal, ref);

          _showUndoSnackBar(
              context, ref, 'Added ${meal.name} to your cookbook', meal, true);
        } else {
          _confirmRatingDialog(context, ref, Rating.like);
        }

        ref.read(isButlerLoadingProvider.notifier).state = false;
      },
      child: const Icon(
        Icons.favorite,
        size: 30,
      ),
    );
  }

  SizedBox _dismissibleMealCard(
      WidgetRef ref, Meal meal, BuildContext context) {
    return SizedBox(
      height: 350,
      child: Dismissible(
        onUpdate: (details) {
          if (details.direction == DismissDirection.endToStart) {
            ref.read(swipeIsLikeProvider.notifier).state = false;
          } else {
            ref.read(swipeIsLikeProvider.notifier).state = true;
          }

          if (details.reached == true) {
            ref.read(wasJustDismissedProvider.notifier).state = true;
          }
        },
        background: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ref.watch(swipeIsLikeProvider)
                ? const Icon(Icons.favorite)
                : const SizedBox(),
            ref.watch(swipeIsLikeProvider)
                ? const SizedBox()
                : const Icon(Icons.not_interested),
          ],
        ),
        key: Key(meal.id.toString()),
        onDismissed: (direction) async {
          ref.read(isButlerLoadingProvider.notifier).state = true;

          if (direction == DismissDirection.endToStart) {
            await _dislikedIt(meal, ref);

            _showUndoSnackBar(
                context, ref, '${meal.name} is gone forever', meal, false);
          } else if (direction == DismissDirection.startToEnd) {
            await _likeIt(context, meal, ref);

            _showUndoSnackBar(context, ref,
                'Added ${meal.name} to your cookbook', meal, true);
          }

          ref.read(isButlerLoadingProvider.notifier).state = false;
        },
        child: MealCard(meal: ref.watch(bestMealProvider)),
      ),
    );
  }

  void _showUndoSnackBar(BuildContext context, WidgetRef ref, String message,
      Meal meal, bool isLike) {
    final snackBar = SnackBar(
      action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            ref.read(isButlerLoadingProvider.notifier).state = true;

            await parentRef.read(bestMealProvider.notifier).undoSwipe(meal);

            if (isLike) {
              parentRef.read(consecutiveSwipesProvider.notifier).state -= 1;
            }

            ref.read(isButlerLoadingProvider.notifier).state = false;
          }),
      content: Text(message),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _likeIt(BuildContext context, Meal meal, WidgetRef ref) async {
    await ref.read(userProvider.notifier).addToCookbook(meal);

    ref.read(consecutiveSwipesProvider.notifier).state += 1;

    if (ref.read(consecutiveSwipesProvider) == 3) {
      _confirmRatingDialog(context, ref, Rating.neutral);
    }

    ref.read(wasJustDismissedProvider.notifier).state = false;
  }

  Future<void> _dislikedIt(Meal meal, WidgetRef ref) async {
    await ref.read(userProvider.notifier).discard(meal);

    ref.read(wasJustDismissedProvider.notifier).state = false;
  }

  Future<void> _confirmRatingDialog(
      BuildContext context, WidgetRef ref, Rating rating) async {
    var meal = ref
        .watch(mealsProvider)
        .firstWhere((meal) => meal.id == ref.read(bestMealProvider).id);

    var title = rating == Rating.like
        ? moreLikeThisHeadingLabel
        : lessLikeThisHeadingLabel;

    var message = rating == Rating.like
        ? '$moreLikeThisBodyPartOneLabel ${meal.name.toLowerCase()}$moreLikeThisBodyPartTwoLabel'
        : '$lessLikeThisBodyPartOneLabel ${meal.name.toLowerCase()} $lessLikeThisBodyPartTwoLabel';

    if (rating == Rating.neutral) {
      title = 'Bing Bong!';
      message = 'Whoa there, it\'s getting swipy in here...';

      ref.read(consecutiveSwipesProvider.notifier).state = 0;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
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
              child: ref.watch(isButlerLoadingProvider)
                  ? const Center(child: ProgressSpinner())
                  : ListBody(
                      children: <Widget>[
                        Text(
                          message,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
            ),
            actions: ref.watch(isButlerLoadingProvider)
                ? null
                : _alertDialogActions(context, ref, meal, rating, setState),
          );
        });
      },
    );
  }

  List<Widget> _alertDialogActions(BuildContext context, WidgetRef ref,
      Meal meal, Rating rating, Function(void Function()) setState) {
    List<Widget> list = [];

    if (ref.read(bottomNavProvider.state).state == 1) {
      if (rating == Rating.like) {
        var widget = TextButton(
          child: const Text('Add To Cookbook'),
          onPressed: () async {
            setState(() =>
                () => ref.read(isButlerLoadingProvider.notifier).state = true);

            await _confirmDenyButler(context, ref, rating, meal);
            ref.read(bottomNavProvider.notifier).state = 1;

            setState(() =>
                () => ref.read(isButlerLoadingProvider.notifier).state = false);
          },
        );

        list.add(widget);
      } else if (rating == Rating.dislike) {
        var widget = TextButton(
          child: const Text('Do Better, Butler!'),
          onPressed: () async {
            setState(() =>
                () => ref.read(isButlerLoadingProvider.notifier).state = true);

            await _confirmDenyButler(context, ref, rating, meal);
            ref.read(bottomNavProvider.notifier).state = 1;

            setState(() =>
                () => ref.read(isButlerLoadingProvider.notifier).state = false);
          },
        );

        list.add(widget);
      }
    } else if (rating == Rating.like) {
      var widget = TextButton(
        child: const Text('View In Cookbook'),
        onPressed: () async {
          setState(() =>
              () => ref.read(isButlerLoadingProvider.notifier).state = true);

          await _confirmDenyButler(context, ref, rating, meal);
          ref.read(bottomNavProvider.notifier).state = 1;

          setState(() =>
              () => ref.read(isButlerLoadingProvider.notifier).state = false);
        },
      );

      list.add(widget);
    }

    if (rating == Rating.neutral) {
      var widgetDeny = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Nah, Keep It Coming'),
      );

      var widgetConfirm = TextButton(
        onPressed: () {
          Navigator.pop(context);
          ref.read(bottomNavProvider.notifier).state = 1;
        },
        child: const Text('Yeah, Let\'s Cook'),
      );

      list.add(widgetDeny);
      list.add(widgetConfirm);
    } else if (ref.read(bottomNavProvider) == 0) {
      var widget = TextButton(
        child: rating == Rating.like
            ? const Text('Add & Continue')
            : const Text('Do Better, Butler!'),
        onPressed: () async {
          await _confirmDenyButler(context, ref, rating, meal);
        },
      );

      list.add(widget);
    }

    return list;
  }

  Future<void> _confirmDenyButler(
      BuildContext context, WidgetRef ref, Rating rating, Meal meal) async {
    if (rating == Rating.like) {
      await ref.read(userProvider.notifier).addToCookbook(meal);
    } else if (rating == Rating.dislike) {
      await ref.read(userProvider.notifier).discard(meal);
    }

    Navigator.of(context).pop();
  }
}
