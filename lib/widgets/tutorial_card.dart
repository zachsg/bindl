import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';

class TutorialCard extends StatelessWidget {
  const TutorialCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            cookButton(context),
            const Icon(Icons.arrow_right_alt),
            rateButton(context),
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
              const Text(' in the menu'),
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

  Widget cookButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        const snackBar = SnackBar(
          content: Text('Tap a meal card to get cooking'),
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
                Icons.thumb_up,
                color: Theme.of(context).backgroundColor,
              ),
              const Text(' or '),
              Icon(
                Icons.thumb_down,
                color: Theme.of(context).backgroundColor,
              ),
              const Text(' in a meal to rate after cooking'),
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
          content: Text('Cook your meals and you\'ll get a new plan!'),
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
