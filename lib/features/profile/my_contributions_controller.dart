import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/post.dart';
import '../../providers/providers.dart';
import '../../services/db.dart';

final myContributionsProvider =
    StateNotifierProvider<MyContributionsController, List<Post>>(
        (ref) => MyContributionsController(ref: ref));

class MyContributionsController extends StateNotifier<List<Post>> {
  MyContributionsController({required this.ref}) : super([]);

  final Ref ref;

  Future<bool> load() async {
    ref.read(loadingProvider.notifier).state = true;

    state.clear();

    final response = await DB.loadMyContributions();

    if (response != null) {
      for (final postJson in response) {
        state = [...state, Post.fromJson(postJson)];
      }
    }

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }
}
