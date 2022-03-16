import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../../providers/providers.dart';
import '../../../services/db.dart';
import '../your_profile/your_profile_view.dart';

final yourContributionsProvider =
    StateNotifierProvider<YourContributionsController, List<Post>>(
        (ref) => YourContributionsController(ref: ref));

class YourContributionsController extends StateNotifier<List<Post>> {
  YourContributionsController({required this.ref}) : super([]);

  final Ref ref;

  Future<bool> load() async {
    ref.read(loadingProvider.notifier).state = true;

    state.clear();

    final response =
        await DB.loadYourContributions(ref.watch(otherUserIdProvider));

    if (response != null) {
      for (final postJson in response) {
        state = [...state, Post.fromJson(postJson)];
      }
    }

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }
}
