import 'package:bindl/utils/constants.dart';
import 'package:flutter/material.dart';

class SignInController with ChangeNotifier {
  Future<bool> signUp({required String email, required String password}) async {
    final response = await supabase.auth.signUp(
      email,
      password,
    );

    if (response.error == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signIn(
      email: email,
      password: password,
    );

    if (response.error == null) {
      return true;
    } else {
      return false;
    }
  }
}
