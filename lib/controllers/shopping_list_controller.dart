import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingListController extends ChangeNotifier {
  ShoppingListController(this.ref);
  final Ref ref;

  final List<Ingredient> _shoppingList = [];
  final List<String> _pantry = [];

  List<Ingredient> get all => _shoppingList;

  Future<void> loadPantryIngredients() async {
    final pantryJSON = await DB.getPantryIngredients();

    for (var pantryJson in pantryJSON) {
      for (var ingredient in pantryJson['pantry']) {
        _pantry.add(ingredient);
      }
    }

    notifyListeners();
  }

  Future<void> clearPantry() async {
    await DB.setPantryIngredients([]);

    notifyListeners();
  }

  void buildUnifiedShoppingList() {
    _shoppingList.clear();
    var allIngredients = <Ingredient>[];
    Map<String, Ingredient> unifiedShoppingMap = {};
    var mp = ref.watch(mealPlanProvider);

    for (var meal in mp.all) {
      for (var ingredient in meal.ingredients) {
        var singleServingIngredient = Ingredient(
            name: ingredient.name.split(',').first.toLowerCase().trim(),
            quantity: ingredient.quantity / meal.servings.toDouble(),
            measurement: ingredient.measurement);

        allIngredients.add(singleServingIngredient);
      }
    }

    for (var ingredient in allIngredients) {
      var dirty = false;

      var simpleIngredient =
          ingredient.name.split(',').first.toLowerCase().trim();

      unifiedShoppingMap.forEach((key, value) {
        if (key == simpleIngredient &&
            value.measurement == ingredient.measurement) {
          var name = ingredient.name;
          var measurement = ingredient.measurement;
          var quantity = ingredient.quantity + value.quantity;

          unifiedShoppingMap[key] = Ingredient(
              name: name, quantity: quantity, measurement: measurement);
          dirty = true;
        }
      });

      if (!dirty) {
        unifiedShoppingMap[ingredient.name] = ingredient;
      }
    }

    unifiedShoppingMap.forEach((key, value) {
      _shoppingList.add(value);
    });

    notifyListeners();
  }

  bool ingredientWasBought(Ingredient ingredient) {
    return _pantry.contains(ingredient.name);
  }

  Future<bool> addIngredientToPantry(Ingredient ingredient) async {
    _pantry.add(ingredient.name);

    final success = await DB.setPantryIngredients(_pantry);

    notifyListeners();

    return success;
  }

  Future<bool> removeIngredientFromPantry(Ingredient ingredient) async {
    _pantry
        .removeWhere((ingredientString) => ingredientString == ingredient.name);

    final success = await DB.setPantryIngredients(_pantry);

    notifyListeners();

    return success;
  }
}
