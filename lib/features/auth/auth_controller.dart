import 'package:bodai/services/db.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final emailAuthProvider = StateProvider<String>((ref) => '');
final passwordAuthProvider = StateProvider<String>((ref) => '');
final passwordConfirmAuthProvider = StateProvider<String>((ref) => '');

class AuthController {
  static get isLoggedIn => supabase.auth.currentUser != null;

  static bool passwordsDoMatch(String a, String b) => a == b ? true : false;

  static GotrueSubscription authChanges() {
    final subscription = supabase.auth.onAuthStateChange((event, session) {
      switch (event) {
        case AuthChangeEvent.passwordRecovery:
          // TODO: Handle this case.
          break;
        case AuthChangeEvent.signedIn:
          // TODO: Handle this case.
          break;
        case AuthChangeEvent.signedOut:
          // TODO: Handle this case.
          break;
        case AuthChangeEvent.tokenRefreshed:
          // TODO: Handle this case.
          break;
        case AuthChangeEvent.userUpdated:
          // TODO: Handle this case.
          break;
      }
    });

    return subscription;
  }

  static Future<bool> signUpWithEmailAndPassword(
      String email, String password) async {
    final res = await DB.signUpWithEmailAndPassword(email, password);
    return res.error == null;
  }

  static Future<bool> signInWithEmailAndPassword(
      String email, String password) async {
    final res = await DB.signInWithEmailAndPassword(email, password);
    return res.error == null;
  }

  static Future<bool> signInWithGoogle() async {
    final res = await DB.signInWithGoogle();
    return res;
  }

  static Future<void> signOut() async {
    await DB.signOut();
  }
}
