import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class Auth {
  static Future<GotrueSessionResponse> signUpWithEmailAndPassword(
      String email, String password) async {
    final res = await supabase.auth.signUp(email, password);

    return res;
  }

  static Future<GotrueSessionResponse> signInWithEmailAndPassword(
      String email, String password) async {
    final res = await supabase.auth.signIn(email: email, password: password);

    return res;
  }

  static Future<bool> signInWithGoogle() async {
    final res = await supabase.auth.signInWithProvider(
      Provider.google,
      options: AuthOptions(
          redirectTo:
              'https://qcryzjgjqhavbupdnpdl.supabase.co/auth/v1/callback'),
    );

    return res;
  }

  static Future<bool> signOut() async {
    final response = await supabase.auth.signOut();

    return response.error == null;
  }
}
