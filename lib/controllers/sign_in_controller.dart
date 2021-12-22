import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';

class SignInController with ChangeNotifier {
  Future<bool> signUp({required String email, required String password}) async {
    final success = await DB.signUp(email: email, password: password);
    return success;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final success = await DB.signIn(email: email, password: password);
    return success;
  }
}