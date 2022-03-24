import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../profile/your_profile/your_profile_view.dart';
import '../recipe_controller.dart';

class CreatorButtonWidget extends ConsumerWidget {
  CreatorButtonWidget({Key? key}) : super(key: key);

  final creatorProvider = FutureProvider<String>((ref) async {
    final creatorName = await ref.read(recipeProvider.notifier).creatorName();

    return creatorName;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<String> creatorName = ref.watch(creatorProvider);

    return creatorName.when(
      data: (creatorName) {
        return OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, YourProfileView.routeName);
          },
          child: Text(
            creatorName,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        );
      },
      error: (err, stack) => Text(err.toString()),
      loading: () => const Text('Loading...'),
    );
  }
}
