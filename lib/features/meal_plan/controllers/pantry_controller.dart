import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pantryProvider =
    StateNotifierProvider<PantryController, List<Ingredient>>(
        (ref) => PantryController());

class PantryController extends StateNotifier<List<Ingredient>> {
  PantryController() : super([]);

  Future<void> clear() async {
    state.clear();

    await DB.setPantryIngredients([]);
  }

  bool contains(Ingredient ingredient) {
    for (var pantryIngredient in state) {
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
        state = [...state, Ingredient.fromJson(ingredient)];
      }
    }
  }

  Future<bool> add(Ingredient ingredient) async {
    state = [...state, ingredient];

    var pantryJSON = [];
    for (var i in state) {
      pantryJSON.add(i.toJson());
    }

    final success = await DB.setPantryIngredients(pantryJSON);

    return success;
  }

  Future<bool> remove(Ingredient ingredient) async {
    state = state.where((element) => element.name != ingredient.name).toList();

    var pantryJSON = [];
    for (var i in state) {
      pantryJSON.add(i.toJson());
    }

    final success = await DB.setPantryIngredients(pantryJSON);

    return success;
  }
}
