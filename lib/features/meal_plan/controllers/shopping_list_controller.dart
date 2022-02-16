import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meal_plan_controller.dart';

final shoppingListProvider =
    ChangeNotifierProvider((ref) => ShoppingListController(ref: ref));

// TODO: Convert to StateNotifier
class ShoppingListController extends ChangeNotifier {
  ShoppingListController({required this.ref});

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

  final Ref ref;

  final Map<String, List<Ingredient>> _shoppingList = {};

  Map<String, List<Ingredient>> get all => _shoppingList;

  void load() {
    _shoppingList.clear();

    var allIngredients = <Ingredient>[];
    Map<String, Ingredient> unifiedShoppingMap = {};

    for (var item in ref.read(mealPlanProvider)) {
      var meal = ref.read(mealsProvider.notifier).mealForID(item.mealID);

      for (var ingredient in meal.ingredients) {
        var singleServingIngredient = Ingredient(
            name: ingredient.name.split(',').first.toLowerCase().trim(),
            quantity: ingredient.quantity / meal.servings.toDouble(),
            measurement: ingredient.measurement);

        allIngredients.add(singleServingIngredient);
      }
    }

    // Add ingredient quantities together when ingredient names & measurements match
    for (var ingredient in allIngredients) {
      var dirty = false;

      unifiedShoppingMap.forEach((key, value) {
        if (key == ingredient.name &&
            value.measurement == ingredient.measurement) {
          var quantity = ingredient.quantity + value.quantity;

          unifiedShoppingMap[key] = Ingredient(
              name: ingredient.name,
              quantity: quantity,
              measurement: ingredient.measurement);
          dirty = true;
        }
      });

      if (!dirty) {
        unifiedShoppingMap[ingredient.name] = ingredient;
      }
    }

    // Group ingredients by category
    unifiedShoppingMap.forEach((key, value) {
      var name = value.name.toLowerCase().replaceAll(optionalLabel, '').trim();

      if (Ingredients.eggsDairy.map((e) => e.toLowerCase()).contains(name)) {
        if (_shoppingList.containsKey(eggsDairy)) {
          _shoppingList[eggsDairy]!.add(value);
        } else {
          _shoppingList[eggsDairy] = [value];
        }
      } else if (Ingredients.oilsFats
          .map((e) => e.toLowerCase())
          .contains(name)) {
        if (_shoppingList.containsKey(oilsFats)) {
          _shoppingList[oilsFats]!.add(value);
        } else {
          _shoppingList[oilsFats] = [value];
        }
      } else if (Ingredients.meatFish
          .map((e) => e.toLowerCase())
          .contains(name)) {
        if (_shoppingList.containsKey(meatFish)) {
          _shoppingList[meatFish]!.add(value);
        } else {
          _shoppingList[meatFish] = [value];
        }
      } else if (Ingredients.vegetables
          .map((e) => e.toLowerCase())
          .contains(name)) {
        if (_shoppingList.containsKey(vegetables)) {
          _shoppingList[vegetables]!.add(value);
        } else {
          _shoppingList[vegetables] = [value];
        }
      } else if (Ingredients.fruits
          .map((e) => e.toLowerCase())
          .contains(name)) {
        if (_shoppingList.containsKey(fruits)) {
          _shoppingList[fruits]!.add(value);
        } else {
          _shoppingList[fruits] = [value];
        }
      } else if (Ingredients.condimentsSauces
          .map((e) => e.toLowerCase())
          .contains(name)) {
        if (_shoppingList.containsKey(condimentsSauces)) {
          _shoppingList[condimentsSauces]!.add(value);
        } else {
          _shoppingList[condimentsSauces] = [value];
        }
      } else if (Ingredients.grains
          .map((e) => e.toLowerCase())
          .contains(name)) {
        if (_shoppingList.containsKey(grains)) {
          _shoppingList[grains]!.add(value);
        } else {
          _shoppingList[grains] = [value];
        }
      } else if (Ingredients.nutsSeedsBeans
          .map((e) => e.toLowerCase())
          .contains(name)) {
        if (_shoppingList.containsKey(nutsSeedsBeans)) {
          _shoppingList[nutsSeedsBeans]!.add(value);
        } else {
          _shoppingList[nutsSeedsBeans] = [value];
        }
      } else if (Ingredients.spices
          .map((e) => e.toLowerCase())
          .contains(name)) {
        if (_shoppingList.containsKey(spices)) {
          _shoppingList[spices]!.add(value);
        } else {
          _shoppingList[spices] = [value];
        }
      } else if (Ingredients.sweeteners
          .map((e) => e.toLowerCase())
          .contains(name)) {
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
}
