import 'data_constants.dart';

class Auth {
  static get isLoggedIn => supabase.auth.currentUser != null;

  static Future<bool> signUp(
      {required String email, required String password}) async {
    final response = await supabase.auth.signUp(
      email,
      password,
    );

    return response.error == null;
  }

  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signIn(
      email: email,
      password: password,
    );

    return response.error == null;
  }

  static Future<bool> signOut() async {
    final response = await supabase.auth.signOut();

    return response.error == null;
  }
}
