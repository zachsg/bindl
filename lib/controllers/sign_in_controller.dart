import 'package:bodai/data/xdata.dart';
import 'package:flutter/material.dart';

class SignInController with ChangeNotifier {
  Future<String> signUp(
      {required String email, required String password}) async {
    final response = await Auth.signUp(email: email, password: password);
    return response;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final success = await Auth.signIn(email: email, password: password);
    return success;
  }
}
