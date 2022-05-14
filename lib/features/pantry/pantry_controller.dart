import 'package:bodai/constants.dart';
import 'package:bodai/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/ingredients.dart';
import '../../models/xmodels.dart';
import '../../providers/providers.dart';
import '../../services/db.dart';
import '../discover_recipes/discover_recipes_controller.dart';

final fridgeProvider = StateProvider<List<PantryIngredient>>((ref) {
  final ingredients = ref.watch(pantryProvider);

  final List<PantryIngredient> list = [];
  for (final i in ingredients) {
    if (!i.toBuy) {
      list.add(i);
    }
  }

  return list;
});

final shoppingProvider = StateProvider<List<PantryIngredient>>((ref) {
  final ingredients = ref.watch(pantryProvider);

  final List<PantryIngredient> list = [];
  for (final i in ingredients) {
    if (i.toBuy) {
      list.add(i);
    }
  }

  return list;
});

final pantryProvider =
    StateNotifierProvider<PantryController, List<PantryIngredient>>(
        (ref) => PantryController(ref: ref));

class PantryController extends StateNotifier<List<PantryIngredient>> {
  PantryController({required this.ref}) : super([]);

  final Ref ref;

  Future<bool> load() async {
    ref.read(loadingProvider.notifier).state = true;

    final prefs = await SharedPreferences.getInstance();
    final bool? onboarded = prefs.getBool(onboardingKey);

    if (onboarded != null && onboarded == true) {
      ref.read(didOnboardingProvider.notifier).state = true;
    } else {
      ref.read(didOnboardingProvider.notifier).state = false;
    }

    state.clear();

    final response = await DB.loadPantry();

    state = [for (final pij in response) PantryIngredient.fromJson(pij)];

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }

  Future<bool> loadBought() async {
    ref.read(loadingProvider.notifier).state = true;

    final prefs = await SharedPreferences.getInstance();
    final bool? onboarded = prefs.getBool(onboardingKey);

    if (onboarded != null && onboarded == true) {
      ref.read(didOnboardingProvider.notifier).state = true;
    } else {
      ref.read(didOnboardingProvider.notifier).state = false;
    }

    state.clear();

    final response = await DB.loadPantry();

    state = [
      for (final pij in response)
        if (!PantryIngredient.fromJson(pij).toBuy)
          PantryIngredient.fromJson(pij)
    ];

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }

  Future<bool> loadToBuy() async {
    ref.read(loadingProvider.notifier).state = true;

    final prefs = await SharedPreferences.getInstance();
    final bool? onboarded = prefs.getBool(onboardingKey);

    if (onboarded != null && onboarded == true) {
      ref.read(didOnboardingProvider.notifier).state = true;
    } else {
      ref.read(didOnboardingProvider.notifier).state = false;
    }

    state.clear();

    final response = await DB.loadPantry();

    state = [
      for (final pij in response)
        if (PantryIngredient.fromJson(pij).toBuy) PantryIngredient.fromJson(pij)
    ];

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }

  Future<void> updateExpirationDateForIngredient(
      PantryIngredient ingredient, DateTime newDate) async {
    state = [
      for (final i in state)
        if (i.id == ingredient.id)
          ingredient.copyWith(expiresOn: newDate.toIso8601String())
        else
          i
    ];

    for (final i in state) {
      if (i.id == ingredient.id) {
        var iJson = i.toJson();
        if (i.id == null) {
          iJson.removeWhere((key, value) => key == 'id');
        }
        await DB.updateIngredientInPantry(iJson);
        break;
      }
    }

    await load();
    ref.read(pantryTabIndexProvider.notifier).state = 0;
  }

  Future<void> buyIngredient(PantryIngredient ingredient) async {
    state = [
      for (final i in state)
        if (i.id == ingredient.id) ingredient.copyWith(toBuy: false) else i
    ];

    for (final i in state) {
      if (i.id == ingredient.id) {
        var iJson = i.toJson();
        if (i.id == null) {
          iJson.removeWhere((key, value) => key == 'id');
        }
        await DB.updateIngredientInPantry(iJson);
        break;
      }
    }

    await load();
    ref.read(pantryTabIndexProvider.notifier).state = 1;
  }

  Future<bool> addIngredient({
    required Ingredient ingredient,
    required bool toBuy,
    required bool buyTab,
  }) async {
    PantryIngredient pantryIngredient = PantryIngredient(
      ownerId: supabase.auth.currentUser!.id,
      addedOn: DateTime.now().toIso8601String(),
      expiresOn: DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),

      // !buyTab
      //     ? ref.read(expiresOnProvider).toIso8601String()
      //     : DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      ingredient: ingredient,
      toBuy: toBuy ? true : false,
    );

    state = [
      ...[pantryIngredient],
      ...state
    ];

    final pantryIngredientJson = pantryIngredient.toJson();
    pantryIngredientJson.removeWhere((key, value) => key == 'id');

    final success = await DB.updateIngredientInPantry(pantryIngredientJson);

    if (buyTab) {
      await load();
      ref.read(pantryTabIndexProvider.notifier).state = 1;
    } else {
      await load();
      ref.read(pantryTabIndexProvider.notifier).state = 0;
    }

    ref.refresh(recipesFutureProvider);

    return success;
  }

  Future<bool> removeIngredientAtIndex(int index) async {
    final ingredient = state[index];

    state = state.where((i) => i != ingredient).toList();

    final success = await DB.removeIngredientFromPantry(ingredient.id!);

    ref.refresh(recipesFutureProvider);

    return success;
  }

  Future<bool> removeIngredientWithId(PantryIngredient ingredient) async {
    // state = state.where((i) => i.id != ingredient.id).toList();

    state = [
      for (final i in state)
        if (i.id != ingredient.id) i
    ];

    final success = await DB.removeIngredientFromPantry(ingredient.id!);
    return success;
  }

  PantryIngredient ingredientWithId(int id) {
    return state.firstWhere((element) => element.ingredient.id == id);
  }

  Future<void> addIngredientQuantities(Ingredient i1, Ingredient i2) async {
    double quantity1;
    if (i1.measurement == IngredientMeasure.ingredient) {
      quantity1 = i1.quantity * Ingredients.gramsPerIngredientFor(i1);
    } else {
      quantity1 = i1.quantity.toGramsFrom(i1.measurement);
    }

    double quantity2;
    if (i2.measurement == IngredientMeasure.ingredient) {
      quantity2 = i2.quantity * Ingredients.gramsPerIngredientFor(i2);
    } else {
      quantity2 = i2.quantity.toGramsFrom(i2.measurement);
    }

    Ingredient ingredient;
    if (i1.measurement == IngredientMeasure.ingredient ||
        i2.measurement == IngredientMeasure.ingredient) {
      final quantity =
          ((quantity1 + quantity2) / Ingredients.gramsPerIngredientFor(i1))
              .ceil();
      ingredient = i1.copyWith(
          quantity: quantity.toDouble(),
          measurement: IngredientMeasure.ingredient);
    } else {
      final quantity = (quantity1 + quantity2).fromGramsTo(i1.measurement);
      ingredient = i1.copyWith(quantity: quantity);
    }

    await updateIngredientQuantity(
        ingredient.id, ingredient.quantity, ingredient.measurement);
  }

  Future<void> subtractIngredientQuantities(
      Ingredient i1, Ingredient i2) async {
    double quantity1;
    if (i1.measurement == IngredientMeasure.ingredient) {
      quantity1 = i1.quantity * Ingredients.gramsPerIngredientFor(i1);
    } else {
      quantity1 = i1.quantity.toGramsFrom(i1.measurement);
    }

    double quantity2;
    if (i2.measurement == IngredientMeasure.ingredient) {
      quantity2 = i2.quantity * Ingredients.gramsPerIngredientFor(i2);
    } else {
      quantity2 = i2.quantity.toGramsFrom(i2.measurement);
    }

    Ingredient ingredient;
    double quantity;
    if (i1.measurement == IngredientMeasure.ingredient ||
        i2.measurement == IngredientMeasure.ingredient) {
      quantity =
          ((quantity1 - quantity2) / Ingredients.gramsPerIngredientFor(i1));
      ingredient = i1.copyWith(
          quantity: quantity.toDouble(),
          measurement: IngredientMeasure.ingredient);
    } else {
      quantity = (quantity1 - quantity2).fromGramsTo(i1.measurement);
      ingredient = i1.copyWith(quantity: quantity);
    }

    if (quantity < 0.1) {
      final pantryIngredient =
          state.firstWhere((element) => element.ingredient.id == ingredient.id);
      await removeIngredientWithId(pantryIngredient);
    } else {
      await updateIngredientQuantity(
          ingredient.id, ingredient.quantity, ingredient.measurement);
    }
  }

  Future<void> updateIngredientQuantity(
      int id, double quantity, IngredientMeasure measure) async {
    state = [
      for (final ingredient in state)
        if (ingredient.ingredient.id == id)
          ingredient.copyWith(
              ingredient: ingredient.ingredient.copyWith(
            quantity: quantity,
            measurement: measure,
          ))
        else
          ingredient
    ];

    for (final i in state) {
      if (i.ingredient.id == id) {
        var iJson = i.toJson();
        if (i.id == null) {
          iJson.removeWhere((key, value) => key == 'id');
        }
        await DB.updateIngredientInPantry(iJson);
        break;
      }
    }
  }

  void ingredientsInPantryFrom(Recipe recipe) {
    final List<String> list = [];
    for (final i in state) {
      list.add(i.ingredient.name);
    }

    final List<Ingredient> ingredients = [];
    for (final i in recipe.ingredients) {
      if (list.contains(i.name)) {
        ingredients.add(i);
      }
    }

    if (ingredients.length == recipe.ingredients.length) {
      ref.read(ownsAllIngredientsProvider.notifier).state = true;
    } else {
      ref.read(ownsAllIngredientsProvider.notifier).state = false;
    }
  }

  void ingredientsInFridgeFrom(Recipe recipe) {
    final List<PantryIngredient> list = [];
    for (final i in state) {
      if (!i.toBuy) {
        list.add(i);
      }
    }

    final List<Ingredient> fridgeList = [];
    for (final i in list) {
      fridgeList.add(i.ingredient);
    }

    final fridgeIds = [];
    for (final i in list) {
      fridgeIds.add(i.ingredient.id);
    }

    final List<Ingredient> inFridgeIngredients = [];
    for (final i in recipe.ingredients) {
      if (fridgeIds.contains(i.id)) {
        final fi = fridgeList.firstWhere((element) => element.id == i.id);

        double fiq;
        if (fi.measurement == IngredientMeasure.ingredient) {
          fiq = fi.quantity * Ingredients.gramsPerIngredientFor(fi);
        } else {
          fiq = fi.quantity.toGramsFrom(fi.measurement);
        }

        double riq;
        if (i.measurement == IngredientMeasure.ingredient) {
          riq = i.quantity * Ingredients.gramsPerIngredientFor(i);
        } else {
          riq = i.quantity.toGramsFrom(i.measurement);
        }

        if (fiq >= riq) {
          inFridgeIngredients.add(i);
        }
      }
    }

    if (inFridgeIngredients.length == recipe.ingredients.length) {
      ref.read(hasAllIngredientsInFridgeProvider.notifier).state = true;
    } else {
      ref.read(hasAllIngredientsInFridgeProvider.notifier).state = false;
    }
  }
}
