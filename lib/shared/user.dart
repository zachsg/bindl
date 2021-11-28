import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/tag.dart';
import 'package:flutter/material.dart';

class User {
  final String name;
  final Map<Tag, int> tags;
  final Map<Allergy, bool> allergies;
  final List<String> adoreIngredients;
  final List<String> abhoreIngredients;

  User({
    required this.name,
    required this.tags,
    required this.allergies,
    required this.adoreIngredients,
    required this.abhoreIngredients,
  });
}

class UserController extends ChangeNotifier {
  final _user = User(
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
    abhoreIngredients: [],
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
    _user.abhoreIngredients.add(ingredient);
    notifyListeners();
  }

  void removeAbhorIngredient(String ingredient) {
    _user.abhoreIngredients.removeWhere((element) => element == ingredient);
    notifyListeners();
  }

  List<String> abhorIngrdients() {
    return _user.abhoreIngredients;
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
}
