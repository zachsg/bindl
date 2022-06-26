import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoRecipesFoundWidget extends ConsumerWidget {
  const NoRecipesFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'No recipes found!\nTry changing your filters.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
