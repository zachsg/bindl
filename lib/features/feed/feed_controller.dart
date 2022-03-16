import 'package:bodai/features/profile/my_contributions/my_contributions_controller.dart';
import 'package:bodai/providers/providers.dart';
import 'package:bodai/providers/user_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/post.dart';
import '../../services/db.dart';
import '../profile/my_liked_posts/my_liked_posts_controller.dart';

final feedProvider = StateNotifierProvider<FeedController, List<Post>>(
    (ref) => FeedController(ref: ref));

class FeedController extends StateNotifier<List<Post>> {
  FeedController({required this.ref}) : super([]);

  final Ref ref;

  Future<bool> loadFeed() async {
    ref.read(loadingProvider.notifier).state = true;

    state.clear();

    final response = await DB.loadFeed();

    for (final postJson in response) {
      state = [...state, Post.fromJson(postJson)];
    }

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }

  Future<bool> loadFeedFromUsers() async {
    ref.read(loadingProvider.notifier).state = true;

    state.clear();

    final response =
        await DB.loadFeedFromUsers(ref.read(userProvider).following);

    for (final postJson in response) {
      state = [...state, Post.fromJson(postJson)];
    }

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }

  Future<bool> like(Post post) async {
    if (post.likes.contains(supabase.auth.currentUser!.id)) {
      state = [
        for (final p in state)
          if (p.id == post.id)
            Post(
              id: post.id,
              updatedAt: post.updatedAt,
              ownerId: post.ownerId,
              recipeId: post.recipeId,
              imageUrl: post.imageUrl,
              videoUrl: post.videoUrl,
              message: post.message,
              comments: post.comments,
              likes: post.likes
                  .where((id) => id != supabase.auth.currentUser!.id)
                  .toList(),
            )
          else
            p
      ];
    } else {
      state = [
        for (final p in state)
          if (p.id == post.id)
            Post(
              id: post.id,
              updatedAt: post.updatedAt,
              ownerId: post.ownerId,
              recipeId: post.recipeId,
              imageUrl: post.imageUrl,
              videoUrl: post.videoUrl,
              message: post.message,
              comments: post.comments,
              likes: [...post.likes, supabase.auth.currentUser!.id],
            )
          else
            p
      ];
    }

    final p = state.where((p) => p.id == post.id).toList().first;

    final success = await DB.updatePost(p.toJson());

    ref.read(myLikedPostsProvider.notifier).like(post);
    ref.read(myContributionsProvider.notifier).load();

    return success;
  }
}
