import 'dart:math';

import 'package:bodai/utils/strings.dart';

import 'data_constants.dart';

class Auth {
  static get isLoggedIn => supabase.auth.currentUser != null;

  static Future<String> signUp(
      {required String email, required String password}) async {
    final response = await supabase.auth.signUp(
      email,
      password,
    );

    if (response.error == null) {
      return successLabel;
    } else {
      return response.error?.message ?? errorLabel;
    }
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
