import 'dart:io';

import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
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

    return response.error == null;
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

  static Future<dynamic> loadAllMealsOwnedBy(String ownerID) async {
    final response =
        await supabase.from('recipes').select().eq('owner', ownerID).execute();

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

  static Future<bool> setServings(String userID, int servings) async {
    final response = await supabase
        .from('profiles')
        .update({'servings': servings})
        .eq('id', userID)
        .execute();

    return response.error == null;
  }

  static Future<bool> uploadRecipePhoto(XFile image) async {
    final imagex = decodeImage(File(image.path).readAsBytesSync());

    if (imagex != null) {
      final thumbnail = copyResize(imagex, width: 600);

      final extension = image.path.split('.').last;
      final reducedPath = image.path + 'reduced.' + extension;

      File file = await File(reducedPath).writeAsBytes(encodePng(thumbnail));

      final response =
          await supabase.storage.from('avatars').upload(image.name, file);

      return response.error == null;
    }

    return false;
  }

  static Future<String> getRecipePhotoURLForImage(String imageName) async {
    final response =
        await supabase.storage.from('avatars').getPublicUrl(imageName);

    if (response.error == null) {
      if (response.data != null) {
        return response.data!;
      }
    } else {
      return response.error.toString();
    }

    return '';
  }

  static Future<bool> saveRecipe(Map<String, dynamic> updates) async {
    final response = await supabase.from('recipes').upsert(updates).execute();

    return response.error == null;
  }

  static Future<dynamic> getUserWithID(String id) async {
    print(id);
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .single()
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }
}
