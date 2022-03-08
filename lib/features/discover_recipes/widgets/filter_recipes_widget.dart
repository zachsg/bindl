import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final mySavedRecipesProvider = StateProvider<int>((ref) => 0);

class FilterRecipesWidget extends ConsumerWidget {
  const FilterRecipesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('All recipes'),
          leading: Radio<int>(
            value: 0,
            groupValue: ref.watch(mySavedRecipesProvider),
            onChanged: (int? value) {
              ref.read(mySavedRecipesProvider.notifier).state = 0;
            },
          ),
        ),
        ListTile(
          title: const Text('Saved recipes'),
          leading: Radio<int>(
            value: 1,
            groupValue: ref.watch(mySavedRecipesProvider),
            onChanged: (int? value) {
              ref.read(mySavedRecipesProvider.notifier).state = 1;
            },
          ),
        ),
      ],
    );
  }
}
