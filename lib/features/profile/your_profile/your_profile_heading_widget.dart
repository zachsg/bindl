import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/other_user_controller.dart';
import '../../../providers/providers.dart';
import '../../shared_widgets/user_list_widget.dart';

class YourProfileHeadingWidget extends ConsumerWidget {
  const YourProfileHeadingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 40,
            child: ref.watch(otherUserProvider).avatar.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: ref.watch(otherUserProvider).avatar,
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.restaurant_menu),
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
                  GestureDetector(
                    onTap: () {
                      ref.read(followerFollowingIdsProvider.notifier).state =
                          ref.read(otherUserProvider).followers;

                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.70,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context2) {
                          return const UserListWidget(title: 'Followers');
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.watch(otherUserProvider).followers.isNotEmpty
                              ? '${ref.watch(otherUserProvider).followers.length}'
                              : '0',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        const Text('Followers'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ref.read(followerFollowingIdsProvider.notifier).state =
                          ref.read(otherUserProvider).following;

                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.70,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context2) {
                          return const UserListWidget(title: 'Following');
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.watch(otherUserProvider).following.isNotEmpty
                              ? '${ref.watch(otherUserProvider).following.length}'
                              : '0',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        const Text('Following'),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              ref.watch(iAmFollowingProvider)
                  ? OutlinedButton(
                      onPressed: () async {
                        await ref.read(otherUserProvider.notifier).follow();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Following'),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        await ref.read(otherUserProvider.notifier).follow();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Follow'),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
