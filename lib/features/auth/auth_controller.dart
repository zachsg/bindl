import '../../constants.dart';
import '../../services/auth.dart';

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
