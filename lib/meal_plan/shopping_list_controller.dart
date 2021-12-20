import 'package:flutter/material.dart';
import 'ingredient.dart';

class ShoppingListController extends ChangeNotifier {
  List<Ingredient> _shoppingList = [];

  List<Ingredient> get all => _shoppingList;

  void buildUnifiedShoppingList(List<Ingredient> shoppingList) {
    _shoppingList = [];

    Map<String, Ingredient> unifiedShoppingMap = {};

    for (var ingredient in shoppingList) {
      var dirty = false;

      var simpleIngredient = ingredient.name.split(',').first.trim();

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
}
