import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseURL = 'https://jtsktndbkvgansrlzkia.supabase.co';
const supabasePublicKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNzUxNjYzOSwiZXhwIjoxOTUzMDkyNjM5fQ.K4Kg0WY0f4mmzU__7PQI4u-6CX1Q_KjFGn17XKURmUA';
final supabase = Supabase.instance.client;

class DB {
  static final currentUser = supabase.auth.currentUser;

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

  static Future<dynamic> loadUserData() async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', currentUser!.id)
        .single()
        .execute();

    if (response.error == null) {
      return response.data;
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

  static Future<dynamic> loadMealsWithIDs(List<int> ids) async {
    final response =
        await supabase.from('recipes').select().in_('id', ids).execute();

    if (response.error == null) {
      return response.data;
    }
  }

  // TODO: Supabase has a bug with 'not in' clauses, use this method once they fix it
  static Future<dynamic> loadAllMealsWithoutAllergies(
      List<String> allergies) async {
    final response = await supabase
        .from('recipes')
        .select()
        .not('allergies', 'in', allergies)
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadAllMeals() async {
    final response = await supabase.from('recipes').select().execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<bool> setMealPlan(String userID, List<int> recipeIDs) async {
    final response = await supabase
        .from('profiles')
        .update({'recipes': recipeIDs})
        .eq('id', userID)
        .execute();

    return response.error == null;
  }

  static Future<bool> setRatings(
      String userID, List<int> mealIDs, bool isLiked) async {
    var column = isLiked ? 'recipes_old_liked' : 'recipes_old_disliked';

    final response = await supabase
        .from('profiles')
        .update({column: mealIDs})
        .eq('id', userID)
        .execute();

    return response.error == null;
  }
}
