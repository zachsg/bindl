import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingListController extends ChangeNotifier {
  ShoppingListController();

  final List<Ingredient> _shoppingList = [];

  List<Ingredient> get all => _shoppingList;

  void buildUnifiedShoppingList(WidgetRef ref) {
    _shoppingList.clear();
    var allIngredients = <Ingredient>[];
    Map<String, Ingredient> unifiedShoppingMap = {};

    for (var meal in ref.watch(mealPlanProvider).all) {
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
}
