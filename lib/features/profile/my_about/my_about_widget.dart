import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/user_controller.dart';

class MyAboutWidget extends ConsumerWidget {
  const MyAboutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.emoji_events),
              Text(
                ' Skill level: ${ref.watch(userProvider).experience.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            ref.watch(userProvider).bio,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
