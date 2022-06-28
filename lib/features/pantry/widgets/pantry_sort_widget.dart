import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pantry_controller.dart';

class PantrySortWidget extends ConsumerWidget {
  const PantrySortWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(sortAlphabeticallyProvider.notifier).state =
          !ref.watch(sortAlphabeticallyProvider),
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 8.0),
        child: Column(
          children: [
            Icon(
              Icons.sort,
              color: Theme.of(context).colorScheme.primary,
            ),
            ref.watch(sortAlphabeticallyProvider)
                ? Icon(
                    Icons.abc,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : Icon(
                    Icons.schedule,
                    color: Theme.of(context).colorScheme.primary,
                  ),
          ],
        ),
      ),
    );
  }
}
