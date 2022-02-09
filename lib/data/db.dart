import 'dart:io';

import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import 'data_constants.dart';

class DB {
  static Future<dynamic> loadUserData() async {
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

  static Future<dynamic> getAllMealsInPlans() async {
    final response = await supabase.from('planned').select().execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> getAllCookedMeals() async {
    final response = await supabase.from('cooked').select().execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadMealPlan(String userID) async {
    final response = await supabase
        .from('planned')
        .select()
        .eq('profile_id', userID)
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<bool> addMealToPlan(
      String userID, int recipeID, String planName, DateTime plannedFor) async {
    final response = await supabase.from('planned').upsert({
      'updated_at': DateTime.now().toIso8601String(),
      'profile_id': userID,
      'recipe_id': recipeID,
      'name': planName,
      'planned_for': plannedFor.toIso8601String()
    }).execute();

    return response.error == null;
  }

  static Future<bool> removeFromMealPlan(
      String userID, int recipeID, String planName, DateTime plannedFor) async {
    final response = await supabase
        .from('planned')
        .delete()
        .eq('profile_id', userID)
        .eq('recipe_id', recipeID)
        .eq('name', planName)
        .execute();

    return response.error == null;
  }

  static Future<bool> setRatings(
      String userID, List<int> mealIDs, bool isLiked) async {
    var column = isLiked ? 'recipes_old_liked' : 'recipes_old_disliked';

    final response = await supabase
        .from('profiles')
        .update({
          'updated_at': DateTime.now().toIso8601String(),
          column: mealIDs,
        })
        .eq('id', userID)
        .execute();

    if (isLiked) {
      final response2 = await supabase.from('cooked').upsert({
        'created_at': DateTime.now().toIso8601String(),
        'recipe_id': mealIDs.last,
        'profile_id': userID,
      }).execute();
    }

    return response.error == null;
  }

  static Future<bool> setServings(String userID, int servings) async {
    final response = await supabase
        .from('profiles')
        .update({
          'updated_at': DateTime.now().toIso8601String(),
          'servings': servings,
        })
        .eq('id', userID)
        .execute();

    return response.error == null;
  }

  static Future<bool> setNumMeals(String userID, int numMeals) async {
    final response = await supabase
        .from('profiles')
        .update({
          'updated_at': DateTime.now().toIso8601String(),
          'num_meals': numMeals,
        })
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

  static Future<dynamic> getAllUsers() async {
    final response = await supabase.from('profiles').select().execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> getPantryIngredients() async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('profiles')
        .select('pantry')
        .eq('id', supabase.auth.currentUser!.id)
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<bool> setPantryIngredients(List<dynamic> ingredients) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response = await supabase
        .from('profiles')
        .update({'pantry': ingredients})
        .eq('id', supabase.auth.currentUser!.id)
        .execute();

    return response.error == null;
  }

  static Future<bool> addComment(int mealID, List<dynamic> comments) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response = await supabase
        .from('recipes')
        .update({'comments': comments})
        .eq('id', mealID)
        .execute();

    return response.error == null;
  }
}
