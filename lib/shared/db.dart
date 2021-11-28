import 'package:bindl/utils/constants.dart';

class DB {
  static Future<bool> signUp(
      {required String email, required String password}) async {
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

  static final currentUser = supabase.auth.currentUser;

  static Future<bool> signIn({
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

  static Future<bool> saveUserData(Map<String, dynamic> updates) async {
    final response = await supabase.from('profiles').upsert(updates).execute();

    if (response.error == null) {
      return true;
    } else {
      return false;
    }
  }
}
