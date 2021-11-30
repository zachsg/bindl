import 'package:bindl/utils/helper.dart';
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
  );

  List<int> recipes() => _user.recipes;

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
      final name = (data['username'] ?? '') as String;
      final tags = Helper.tagsJsonToMap(data['tags']);
      final allergies = Helper.allergyJsonToMap(data['allergies']);

      var dynamicList = (data['adore_ingredients']) as List<dynamic>;
      final adoreIngredients = List<String>.from(dynamicList);

      dynamicList = (data['abhor_ingredients']) as List<dynamic>;
      final abhorIngredients = List<String>.from(dynamicList);

      dynamicList = (data['recipes'] ?? <int>[]) as List<dynamic>;
      final recipes = List<int>.from(dynamicList);

      _user = User(
        name: name,
        tags: tags,
        allergies: allergies,
        adoreIngredients: adoreIngredients,
        abhorIngredients: abhorIngredients,
        recipes: recipes,
      );
    }
  }

  Future<bool> saveUserData() async {
    if (DB.currentUser != null) {
      final id = DB.currentUser!.id;
      final userName = DB.currentUser?.email?.split('@').first ?? "";
      final tags = _user.tags;
      final allergies = _user.allergies;

      final updates = {
        'id': id,
        'updated_at': DateTime.now().toIso8601String(),
        'username': userName,
        'adore_ingredients': _user.adoreIngredients,
        'abhor_ingredients': _user.abhorIngredients,
        'tags': Helper.tagsMapToJson(tags),
        'allergies': Helper.allergyMapToJson(allergies),
      };

      final success = await DB.saveUserData(updates);
      if (success) {
        return true;
      } else {
        return false;
      }
    } else {
      // TODO: Not authenticated, handle error
      return false;
    }
  }

  // TODO: Add / remove liked meal

  // TODO: Add / remove disliked meal
}
