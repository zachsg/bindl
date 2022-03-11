import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/user.dart';
import '../services/db.dart';

final otherUserProvider = StateNotifierProvider<OtherUserController, User>(
    (ref) => OtherUserController(ref: ref));

class OtherUserController extends StateNotifier<User> {
  OtherUserController({required this.ref})
      : super(const User(id: '', name: '', handle: '', updatedAt: ''));

  final Ref ref;

  Future<void> loadUserWithId(String id) async {
    final data = await DB.loadUserWithId(id);
    state = User.fromJson(data);
  }
}
