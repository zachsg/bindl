import '../constants.dart';
import '../models/xmodels.dart';

class DB {
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

  static Future<dynamic> loadUsersWithIds(List<String> ids) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final orList = [];
    for (final id in ids) {
      orList.add('id.eq.$id');
    }

    final response = await supabase
        .from('profiles')
        .select()
        .or(orList.join(',').toString())
        .execute();

    if (response.error == null) {
      return response.data;
    }

    return [];
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

  static Future<dynamic> loadPantry() async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('pantries')
        .select()
        .eq('owner_id', supabase.auth.currentUser!.id)
        .order('expires_on', ascending: true)
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<bool> updateIngredientInPantry(
      Map<String, dynamic> updates) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response = await supabase.from('pantries').upsert(updates).execute();

    return response.error == null;
  }

  static Future<bool> removeIngredientFromPantry(int id) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response =
        await supabase.from('pantries').delete().match({'id': id}).execute();

    return response.error == null;
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

  static Future<dynamic> loadDiscoverRecipesWith({
    required List<Diet> diets,
    required List<Cuisine> cuisines,
    required List<Allergy> allergies,
    required List<Appliance> appliances,
  }) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase.from('recipes').select().execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadDiscoverRecipesIFollowWith({
    required List<Diet> diets,
    required List<Cuisine> cuisines,
    required List<Allergy> allergies,
    required List<Appliance> appliances,
    required List<String> following,
  }) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final orList = [];
    for (final follow in following) {
      orList.add('owner_id.eq.$follow');
    }

    final response = await supabase
        .from('recipes')
        .select()
        .or(orList.join(',').toString())
        .execute();

    if (response.error == null) {
      return response.data;
    }
  }

  static Future<dynamic> loadDiscoverRecipesISavedWith({
    required List<Diet> diets,
    required List<Cuisine> cuisines,
    required List<Allergy> allergies,
    required List<Appliance> appliances,
  }) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response = await supabase.from('recipes').select().execute();

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

  static Future<dynamic> loadRecipeWithId(int id) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }

    final response =
        await supabase.from('recipes').select().eq('id', id).execute();

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

  static Future<bool> markAsCooked(int id, int rating) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }

    final response = await supabase.from('cooked').upsert({
      'created_at': DateTime.now().toIso8601String(),
      'user_id': supabase.auth.currentUser!.id,
      'recipe_id': id,
      'rating': rating,
    }).execute();

    return response.error == null;
  }

  /// FEED

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
}
