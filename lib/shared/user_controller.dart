import 'package:flutter/material.dart';

import 'allergy.dart';
import 'db.dart';
import 'tag.dart';
import 'user.dart';

class UserController extends ChangeNotifier {
  User _user = User(
    name: '',
    tags: {},
    allergies: {
      Allergy.soy: false,
      Allergy.gluten: false,
      Allergy.dairy: false,
      Allergy.egg: false,
      Allergy.shellfish: false,
      Allergy.sesame: false,
      Allergy.treeNuts: false,
      Allergy.peanuts: false,
    },
    adoreIngredients: [],
    abhorIngredients: [],
    recipes: [],
    recipesLiked: [],
    recipesDisliked: [],
  );

  List<int> recipes() => _user.recipes;
  List<int> recipesLiked() => _user.recipesLiked;
  List<int> recipesDisliked() => _user.recipesDisliked;

  void setAllergy({required Allergy allergy, bool isAllergic = true}) {
    _user.allergies[allergy] = isAllergic;
    notifyListeners();
  }

  Map<Allergy, bool> allergies() {
    return _user.allergies;
  }

  bool isAllergic(Allergy allergy) {
    return _user.allergies[allergy] ?? false;
  }

  void setAdoreIngredient(String ingredient) {
    _user.adoreIngredients.add(ingredient);
    notifyListeners();
  }

  void removeAdoreIngredient(String ingredient) {
    _user.adoreIngredients.removeWhere((element) => element == ingredient);
    notifyListeners();
  }

  List<String> adoreIngredients() {
    return _user.adoreIngredients;
  }

  void setAbhorIngredient(String ingredient) {
    _user.abhorIngredients.add(ingredient);
    notifyListeners();
  }

  void removeAbhorIngredient(String ingredient) {
    _user.abhorIngredients.removeWhere((element) => element == ingredient);
    notifyListeners();
  }

  List<String> abhorIngredients() {
    return _user.abhorIngredients;
  }

  void setHasAccount(bool hasAccount) {
    _user.hasAccount = hasAccount;
    notifyListeners();
  }

  bool hasAccount() {
    return _user.hasAccount;
  }

  void addTags(List<Tag> tags, bool isLike) {
    for (var tag in tags) {
      if (isLike) {
        if (_user.tags.containsKey(tag)) {
          _user.tags[tag] = _user.tags[tag]! + 1;
        } else {
          _user.tags[tag] = 1;
        }
      } else {
        if (_user.tags.containsKey(tag)) {
          _user.tags[tag] = _user.tags[tag]! - 1;
        } else {
          _user.tags[tag] = -1;
        }
      }
    }

    notifyListeners();
  }

  List<MapEntry<Tag, int>> sortedTags() {
    return _user.tags.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        return diff;
      });
  }

  Future<void> loadUserData() async {
    if (DB.currentUser != null) {
      final data = await DB.loadUserData();
      _user = User.fromJson(data);
    }
  }

  Future<bool> saveUserData() async {
    if (DB.currentUser != null) {
      final id = DB.currentUser!.id;
      final user = _user.toJson();

      final updates = {
        'id': id,
        'updated_at': DateTime.now().toIso8601String(),
        'username':
            user['name'] ?? DB.currentUser!.email?.split('@').first ?? '',
        'adore_ingredients': user['adore_ingredients'] ?? [],
        'abhor_ingredients': user['abhor_ingredients'] ?? [],
        'recipes_old_liked': user['recipes_old_liked'] ?? [],
        'recipes_old_disliked': user['recipes_old_disliked'] ?? [],
        'recipes': user['recipes'] ?? [],
        'tags': user['tags'] ?? {},
        'allergies': user['allergies'] ?? {},
      };

      final success = await DB.saveUserData(updates);
      if (success) {
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } else {
      // TODO: Not authenticated, handle error
      return false;
    }
  }

  /// Compute meal plan for User
  /// Set `recipes` property to list of integers of relevant meal IDs.
  Future<void> computeMealPlan() async {
    _user.clearRecipes();

    // TODO: Write algorithm to compute user's meal plan

    _user.recipes.add(2); // TODO: Testing only, add real values instead in prod
    _user.recipes.add(3); // TODO: Testing only, add real values instead in prod

    final id = DB.currentUser!.id;
    final user = _user.toJson();

    await DB.setMealPlan(id, user['recipes']);

    notifyListeners();
  }

  // TODO: Add / remove liked meal

  // TODO: Add / remove disliked meal
}
