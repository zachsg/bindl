import 'package:bodai/providers/user_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  }

  Future<void> follow() async {
    final myId = ref.read(userProvider).id;

    if (state.followers.contains(myId)) {
      List<String> followers = List.from(state.followers);
      followers.removeWhere((id) => id == myId);
      state = state.copyWith(followers: followers);
    } else {
      state = state.copyWith(followers: [...state.followers, myId]);
    }

    await ref.read(userProvider.notifier).follow(state.id);

    await DB.saveUser(state.toJson());
  }

  void setupSelf(User user) {
    state = user;
  }
}
