import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';

class PantryController extends ChangeNotifier {
  final List<Ingredient> _pantry = [];

  Future<void> clear() async {
    _pantry.clear();

    notifyListeners();

    await DB.setPantryIngredients([]);
  }

  bool contains(Ingredient ingredient) {
    for (var pantryIngredient in _pantry) {
      if (pantryIngredient.name == ingredient.name) {
        return true;
      }
    }

    return false;
  }

  Future<void> load() async {
    final pantryJSON = await DB.getPantryIngredients();

    for (var fullPantry in pantryJSON) {
      var ingredients = fullPantry['pantry'];

      for (var ingredient in ingredients) {
        _pantry.add(Ingredient.fromJson(ingredient));
      }
    }

    notifyListeners();
  }

  Future<bool> add(Ingredient ingredient) async {
    _pantry.add(ingredient);

    notifyListeners();

    var pantryJSON = [];
    for (var i in _pantry) {
      pantryJSON.add(i.toJson());
    }

    final success = await DB.setPantryIngredients(pantryJSON);

    return success;
  }

  Future<bool> remove(Ingredient ingredient) async {
    _pantry.removeWhere(
        (pantryIngredient) => pantryIngredient.name == ingredient.name);

    notifyListeners();

    var pantryJSON = [];
    for (var i in _pantry) {
      pantryJSON.add(i.toJson());
    }

    final success = await DB.setPantryIngredients(pantryJSON);

    return success;
  }
}
