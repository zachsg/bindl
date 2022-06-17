import 'package:bodai/providers/user_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants.dart';
import '../models/user.dart';
import '../services/db.dart';
import 'providers.dart';

final otherUserProvider = StateNotifierProvider<OtherUserController, User>(
    (ref) => OtherUserController(ref: ref));

class OtherUserController extends StateNotifier<User> {
  OtherUserController({required this.ref})
      : super(const User(id: '', name: '', handle: '', updatedAt: ''));

  final Ref ref;

  Future<void> load() async {
    final data = await DB.loadUserWithId(ref.read(otherUserIdProvider));
    state = User.fromJson(data);

    ref.read(iAmFollowingProvider.notifier).state =
        state.followers.contains(supabase.auth.currentUser!.id);
  }

  Future<void> follow() async {
    if (state.followers.contains(supabase.auth.currentUser!.id)) {
      List<String> followers = List.from(state.followers);
      followers.removeWhere((id) => id == supabase.auth.currentUser!.id);

      state = state.copyWith(followers: followers);
      await ref.read(userProvider.notifier).follow(state.id);
    } else {
      state = state.copyWith(
          followers: [...state.followers, supabase.auth.currentUser!.id]);
      await ref.read(userProvider.notifier).follow(state.id);
    }

    ref.read(iAmFollowingProvider.notifier).state =
        state.followers.contains(supabase.auth.currentUser!.id);

    await DB.saveUser(state.toJson());
  }

  void setupSelf(User user) {
    state = user;

    ref.read(iAmFollowingProvider.notifier).state =
        state.followers.contains(supabase.auth.currentUser!.id);
  }
}
