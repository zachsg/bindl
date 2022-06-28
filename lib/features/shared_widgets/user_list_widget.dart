import 'package:bodai/features/profile/your_profile/your_profile_view.dart';
import 'package:bodai/providers/other_user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/xmodels.dart';
import '../../providers/providers.dart';
import '../../providers/user_controller.dart';

final usersFutureProvider = FutureProvider.autoDispose<List<User>>((ref) {
  return ref
      .watch(userProvider.notifier)
      .loadUsersWithIds(ref.watch(followerFollowingIdsProvider));
});

class UserListWidget extends ConsumerWidget {
  const UserListWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureUsers = ref.watch(usersFutureProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
          child: Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: futureUsers.when(
              data: (users) => ListView.builder(
                restorationId: 'userList',
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                        onTap: () {
                          ref
                              .read(otherUserProvider.notifier)
                              .setupSelf(users[index]);

                          ref.read(otherUserIdProvider.notifier).state =
                              users[index].id;

                          context.pushNamed(YourProfileView.routeName);
                        },
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 40,
                          child: users[index].avatar.isNotEmpty
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: users[index].avatar,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.face),
                                  ),
                                )
                              : const Icon(Icons.face, size: 48),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              users[index].name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text('@${users[index].handle}')
                          ],
                        )),
                  );
                },
              ),
              error: (e, st) => const Center(child: Text('Error')),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
