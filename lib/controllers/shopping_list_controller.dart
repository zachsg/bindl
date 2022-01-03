import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/models/xmodels.dart';
import 'package:bindl/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingListController extends ChangeNotifier {
  ShoppingListController();

  final Map<String, List<Ingredient>> _shoppingList = {};

  Map<String, List<Ingredient>> get all => _shoppingList;

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
      if (Ingredients.eggsDairy.contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(eggsDairy)) {
          _shoppingList[eggsDairy]!.add(value);
        } else {
          _shoppingList[eggsDairy] = [value];
        }
      } else if (Ingredients.oilsFats.contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(oilsFats)) {
          _shoppingList[oilsFats]!.add(value);
        } else {
          _shoppingList[oilsFats] = [value];
        }
      } else if (Ingredients.meatFish.contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(meatFish)) {
          _shoppingList[meatFish]!.add(value);
        } else {
          _shoppingList[meatFish] = [value];
        }
      } else if (Ingredients.vegetables
          .contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(vegetables)) {
          _shoppingList[vegetables]!.add(value);
        } else {
          _shoppingList[vegetables] = [value];
        }
      } else if (Ingredients.fruits.contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(fruits)) {
          _shoppingList[fruits]!.add(value);
        } else {
          _shoppingList[fruits] = [value];
        }
      } else if (Ingredients.condimentsSauces
          .contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(condimentsSauces)) {
          _shoppingList[condimentsSauces]!.add(value);
        } else {
          _shoppingList[condimentsSauces] = [value];
        }
      } else if (Ingredients.grains.contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(grains)) {
          _shoppingList[grains]!.add(value);
        } else {
          _shoppingList[grains] = [value];
        }
      } else if (Ingredients.nutsSeedsBeans
          .contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(nutsSeedsBeans)) {
          _shoppingList[nutsSeedsBeans]!.add(value);
        } else {
          _shoppingList[nutsSeedsBeans] = [value];
        }
      } else if (Ingredients.spices.contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(spices)) {
          _shoppingList[spices]!.add(value);
        } else {
          _shoppingList[spices] = [value];
        }
      } else if (Ingredients.sweeteners
          .contains(value.name.capitalizeWords())) {
        if (_shoppingList.containsKey(sweeteners)) {
          _shoppingList[sweeteners]!.add(value);
        } else {
          _shoppingList[sweeteners] = [value];
        }
      } else {
        if (value.name.toLowerCase() != 'water') {
          if (_shoppingList.containsKey(misc)) {
            _shoppingList[misc]!.add(value);
          } else {
            _shoppingList[misc] = [value];
          }
        }
      }
    });

    notifyListeners();
  }

  static const oilsFats = 'Oils & Fats';
  static const eggsDairy = 'Eggs & Dairy';
  static const meatFish = 'Meat & Fish';
  static const vegetables = 'Vegetables';
  static const fruits = 'Fruit';
  static const condimentsSauces = 'Condiments & Sauces';
  static const grains = 'Grains';
  static const nutsSeedsBeans = 'Nuts, Seeds, & Beans';
  static const spices = 'Spices';
  static const sweeteners = 'Sweeteners';
  static const misc = 'Misc.';
}
