import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/meal_plan_controller.dart';

class TutorialCardWidget extends ConsumerWidget {
  const TutorialCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            shopButton(context),
            const Icon(Icons.arrow_right_alt),
            cookButton(context, ref),
            const Icon(Icons.arrow_right_alt),
            repeatButton(context),
          ],
        ),
      ),
    );
  }

  Widget shopButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        final snackBar = SnackBar(
          content: Row(
            children: [
              const Text('Tap the '),
              Icon(
                Icons.shopping_basket_outlined,
                color: Theme.of(context).backgroundColor,
              ),
              const Text(' in the menu for your shopping list'),
            ],
          ),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Text(
        shopLabel,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget cookButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        final snackBar = SnackBar(
          content: Text(
              'Tap on ${ref.read(mealPlanProvider).all.first.name} to get cooking'),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Text(
        cookLabel,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget rateButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        final snackBar = SnackBar(
          content: Row(
            children: [
              const Text('Tap the '),
              Icon(
                Icons.check_circle,
                color: Theme.of(context).backgroundColor,
              ),
              const Text(' in a meal to indicate you cooked it'),
            ],
          ),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Text(
        rateLabel,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget repeatButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        const snackBar = SnackBar(
          content:
              Text('Cook each meal. Then select new meals to start a new plan'),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Text(
        repeatLabel,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
