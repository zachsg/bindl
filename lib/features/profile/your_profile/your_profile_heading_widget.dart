import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/other_user_controller.dart';

class YourProfileHeadingWidget extends ConsumerWidget {
  const YourProfileHeadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: CircleAvatar(
            radius: 40,
            child: ref.watch(otherUserProvider).avatar.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      ref.watch(otherUserProvider).avatar,
                      fit: BoxFit.cover,
                      height: 70,
                      width: 70,
                    ),
                  )
                : const Icon(
                    Icons.face,
                    size: 72,
                  ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.watch(otherUserProvider).followers.isNotEmpty
                            ? '${ref.watch(otherUserProvider).followers.length}'
                            : '0',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text('Followers'),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.watch(otherUserProvider).following.isNotEmpty
                            ? '${ref.watch(otherUserProvider).following.length}'
                            : '0',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text('Following'),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
