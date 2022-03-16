import 'package:bodai/extensions.dart';
import 'package:bodai/features/feed/feed_controller.dart';
import 'package:bodai/providers/other_user_controller.dart';
import 'package:bodai/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../discover_recipes/discover_recipes_controller.dart';
import '../../profile/your_profile/your_profile_view.dart';

class PostCardWidget extends HookConsumerWidget {
  const PostCardWidget({Key? key, required this.post}) : super(key: key);

  final Post post;

  Future<User> loadUserWithId() async {
    final data = await DB.loadUserWithId(post.ownerId);
    final user = User.fromJson(data);
    return user;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(loadUserWithId);
    final snapshot = useFuture(future);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: snapshot.hasData &&
                              snapshot.data?.avatar != null &&
                              snapshot.data!.avatar.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                snapshot.data!.avatar,
                                fit: BoxFit.cover,
                                height: 34,
                                width: 34,
                              ),
                            )
                          : const Icon(Icons.face, size: 36),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (snapshot.hasData) {
                            ref.read(otherUserIdProvider.notifier).state =
                                snapshot.data!.id;

                            if (ref.watch(discoverRecipesProvider).isEmpty) {
                              await ref
                                  .watch(discoverRecipesProvider.notifier)
                                  .load();
                            }

                            await ref.read(otherUserProvider.notifier).load();

                            Navigator.pushNamed(
                                context, YourProfileView.routeName);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.hasData
                                      ? snapshot.data!.name
                                      : 'Anon',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.hasData
                                      ? snapshot.data!.updatedAt.toDate()
                                      : '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              snapshot.hasData
                                  ? '@${snapshot.data!.handle}'
                                  : '@?',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 56,
                  top: 8,
                  bottom: 8,
                  right: 8,
                ),
                child: Text(post.message),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          ref.read(feedProvider.notifier).like(post);
                        },
                        icon: post.likes.contains(supabase.auth.currentUser?.id)
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                      ),
                      Text(post.likes.length.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          //TODO: comments view for post (probably bottom sheet)
                        },
                        icon: post.comments.isEmpty
                            ? const Icon(Icons.comment_outlined)
                            : const Icon(Icons.comment),
                      ),
                      Text(post.comments.length.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
