import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/user_controller.dart';
import '../edit_profile_view.dart';

class ProfileHeadingWidget extends ConsumerWidget {
  const ProfileHeadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 40,
            child: ref.watch(userProvider).avatar.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      ref.watch(userProvider).avatar,
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
                        ref.watch(userProvider).followers.isNotEmpty
                            ? '${ref.watch(userProvider).followers.length}'
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
                        ref.watch(userProvider).following.isNotEmpty
                            ? '${ref.watch(userProvider).following.length}'
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
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProfileView.routeName);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Edit Profile'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
