import 'package:bindl/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ingredient.dart';

class ShoppingListController extends ChangeNotifier {
  ShoppingListController(this.ref);
  final Ref ref;

  final List<Ingredient> _shoppingList = [];

  List<Ingredient> get all => _shoppingList;

  void buildUnifiedShoppingList() {
    _shoppingList.clear();
    var allIngredients = <Ingredient>[];
    Map<String, Ingredient> unifiedShoppingMap = {};
    var mp = ref.watch(mealPlanProvider);

    for (var meal in mp.all) {
      for (var ingredient in meal.ingredients) {
        var singleServingIngredient = Ingredient(
            name: ingredient.name,
            quantity: ingredient.quantity / meal.servings,
            measurement: ingredient.measurement);

        allIngredients.add(singleServingIngredient);
      }
    }

    for (var ingredient in allIngredients) {
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
