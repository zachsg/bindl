import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/post.dart';
import '../../services/db.dart';

final newPostProvider = StateNotifierProvider<NewPostController, Post>(
    (ref) => NewPostController());

class NewPostController extends StateNotifier<Post> {
  NewPostController()
      : super(const Post(updatedAt: '', ownerId: '', message: ''));

  void setMessage(String text) => state = state.copyWith(message: text);

  Future<bool> createPost() async {
    //TODO: Do Post validation

    state = state.copyWith(updatedAt: DateTime.now().toIso8601String());
    if (supabase.auth.currentUser != null) {
      state = state.copyWith(ownerId: supabase.auth.currentUser!.id);
    }

    final postJson = state.toJson();
    postJson.removeWhere((key, value) => key == 'id');
    final success = await DB.createPost(postJson);

    return success;
  }
}
