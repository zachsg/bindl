import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/other_user_controller.dart';

class YourAboutWidget extends HookConsumerWidget {
  const YourAboutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.emoji_events),
              Text(
                ' Skill level: ${ref.watch(otherUserProvider).experience.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            ref.watch(otherUserProvider).bio,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
