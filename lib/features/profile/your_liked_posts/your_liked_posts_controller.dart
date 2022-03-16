import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../../providers/providers.dart';
import '../../../services/db.dart';
import '../your_profile/your_profile_view.dart';

final yourLikedPostsProvider =
    StateNotifierProvider<YourLikedPostsController, List<Post>>(
        (ref) => YourLikedPostsController(ref: ref));

class YourLikedPostsController extends StateNotifier<List<Post>> {
  YourLikedPostsController({required this.ref}) : super([]);

  final Ref ref;

  Future<bool> load() async {
    ref.read(loadingProvider.notifier).state = true;

    state.clear();

    final response = await DB.loadMyLikedPosts();

    // if (response != null) {
    //   for (final postJson in response) {
    //     state = [...state, Post.fromJson(postJson)];
    //   }
    // }

    //TODO: This should be handled by postgres, but a bug is preventing filtering
    List<Post> posts = [];
    if (response != null) {
      for (final postJson in response) {
        posts.add(Post.fromJson(postJson));
      }
    }
    posts.removeWhere(
        (element) => !element.likes.contains(ref.watch(otherUserIdProvider)));

    state = posts;

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }

  void like(Post post) async {
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
  }
}
