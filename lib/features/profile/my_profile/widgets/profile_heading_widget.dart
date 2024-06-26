import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/providers.dart';
import '../../../../providers/user_controller.dart';
import '../../../shared_widgets/user_list_widget.dart';
import '../edit_profile_view.dart';

class ProfileHeadingWidget extends ConsumerWidget {
  const ProfileHeadingWidget({super.key});

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
                    child: CachedNetworkImage(
                      imageUrl: ref.watch(userProvider).avatar,
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.face),
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
          child: GestureDetector(
            onTap: () {
              ref.read(followerFollowingIdsProvider.notifier).state =
                  ref.read(userProvider).followers;

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
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        const Text('Followers'),
                      ],
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        ref.read(followerFollowingIdsProvider.notifier).state =
                            ref.read(userProvider).following;

                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.70,
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
                            ref.watch(userProvider).following.isNotEmpty
                                ? '${ref.watch(userProvider).following.length}'
                                : '0',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          const Text('Following'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(EditProfileView.routeName);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
