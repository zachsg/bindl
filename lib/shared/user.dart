import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/db.dart';
import 'package:bindl/shared/tag.dart';
import 'package:flutter/material.dart';

class User {
  final String name;
  final Map<Tag, int> tags;
  final Map<Allergy, bool> allergies;
  final List<String> adoreIngredients;
  final List<String> abhorIngredients;
  final List<int> recipes;
  bool hasAccount;

  User({
    required this.name,
    required this.tags,
    required this.allergies,
    required this.adoreIngredients,
    required this.abhorIngredients,
    required this.recipes,
    this.hasAccount = false,
  });

  static Map<String, dynamic> allergyMapToJson(Map<Allergy, bool> map) {
    Map<String, dynamic> json = {};

    map.forEach((key, value) {
      json[key.index.toString()] = value;
    });

    return json;
  }

  static Map<Allergy, bool> allergyJsonToMap(Map<String, dynamic> json) {
    Map<Allergy, bool> map = {};

    json.forEach((key, value) {
      map[Allergy.values.elementAt(int.parse(key))] = value as bool;
    });

    return map;
  }

  static Map<String, dynamic> tagsMapToJson(Map<Tag, int> map) {
    Map<String, dynamic> json = {};

    map.forEach((key, value) {
      json[key.index.toString()] = value;
    });

    return json;
  }

  static Map<Tag, int> tagsJsonToMap(Map<String, dynamic> json) {
    Map<Tag, int> map = {};

    json.forEach((key, value) {
      map[Tag.values.elementAt(int.parse(key))] = value as int;
    });

    return map;
  }
}

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
      final tags = User.tagsJsonToMap(data['tags']);
      final allergies = User.allergyJsonToMap(data['allergies']);
      final adoreIngredients =
          (data['adore_ingredients'] ?? <String>[]) as List<String>;
      final abhorIngredients =
          (data['abhor_ingredients'] ?? <String>[]) as List<String>;
      final recipes = (data['recipes'] ?? <int>[]) as List<int>;

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
        'tags': User.tagsMapToJson(tags),
        'allergies': User.allergyMapToJson(allergies),
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
}
