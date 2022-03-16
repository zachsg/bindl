import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/allergy.dart';
import '../models/cuisine.dart';
import '../models/diet.dart';

final supabase = Supabase.instance.client;

class DB {
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

  static Future<dynamic> loadUser() async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', supabase.auth.currentUser!.id)
        .single()
        .execute();

    if (response.error == null) {
      return response.data;
    }

    return [];
  }

  static Future<dynamic> loadUserWithId(String id) async {
    if (supabase.auth.currentUser == null) {
      return {String: dynamic};
    }

    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .single()
        .execute();

    if (response.error == null) {
      return response.data;
    }

    return {String: dynamic};
  }

  static Future<bool> saveUser(Map<String, dynamic> updates) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response = await supabase.from('profiles').upsert(updates).execute();

    return response.error == null;
  }

  static Future<bool> createPost(Map<String, dynamic> updates) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response = await supabase.from('posts').insert(updates).execute();

    return response.error == null;
  }

  static Future<bool> updatePost(Map<String, dynamic> updates) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response = await supabase.from('posts').upsert(updates).execute();

    return response.error == null;
  }

  static Stream<List<Map<String, dynamic>>> subscribeToFeed() {
    final stream = supabase.from('posts').stream(['id']).execute();
    return stream;
  }

  static Future<dynamic> loadFeed() async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response =
        await supabase.from('posts').select().order('updated_at').execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadFeedFromUsers(List<String> userIds) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('posts')
        .select()
        .in_('owner_id', userIds)
        .order('updated_at')
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadDiscoverRecipes() async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase.from('recipes').select().execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadDiscoverRecipesWith(
      {required List<Diet> diets,
      required List<Cuisine> cuisines,
      required List<Allergy> allergies,
      required bool onlySaved}) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase.from('recipes').select().execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadMyLikedPosts() async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('posts')
        .select()
        // .contains('likes', [supabase.auth.currentUser!.id])
        .order('updated_at')
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadMyContributions() async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('posts')
        .select()
        .eq('owner_id', supabase.auth.currentUser!.id)
        .order('updated_at')
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadYourContributions(String id) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('posts')
        .select()
        .eq('owner_id', id)
        .order('updated_at')
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadMyRecipes() async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('recipes')
        .select()
        .eq('owner_id', supabase.auth.currentUser!.id)
        .order('updated_at')
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadYourRecipes(String id) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('recipes')
        .select()
        .eq('owner_id', id)
        .order('updated_at')
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<bool> saveRecipe(Map<String, dynamic> updates) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response = await supabase.from('recipes').upsert(updates).execute();

    return response.error == null;
  }
}
