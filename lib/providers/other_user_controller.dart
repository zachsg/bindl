import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/profile/your_profile/your_profile_view.dart';
import '../models/user.dart';
import '../services/db.dart';

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
}
