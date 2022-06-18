import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants.dart';
import '../../services/auth.dart';

final emailAuthProvider = StateProvider<String>((ref) => '');
final passwordAuthProvider = StateProvider<String>((ref) => '');
final passwordConfirmAuthProvider = StateProvider<String>((ref) => '');

class AuthController {
  static get isLoggedIn => supabase.auth.currentUser != null;

  static Future<bool> signIn(String email, kIsWeb) async {
    final res = Auth.signIn(email, kIsWeb);

    return res;
  }

  static Future<void> signOut() async {
    await Auth.signOut();
  }
}
