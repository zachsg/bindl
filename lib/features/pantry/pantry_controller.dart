import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/xmodels.dart';
import '../../providers/providers.dart';
import '../../services/db.dart';

final pantryProvider =
    StateNotifierProvider<PantryController, List<PantryIngredient>>(
        (ref) => PantryController(ref: ref));

class PantryController extends StateNotifier<List<PantryIngredient>> {
  PantryController({required this.ref}) : super([]);

  final Ref ref;

  Future<bool> load() async {
    ref.read(loadingProvider.notifier).state = true;

    state.clear();

    final response = await DB.loadPantry();

    for (final pantryIngredientJson in response) {
      state = [...state, PantryIngredient.fromJson(pantryIngredientJson)];
    }

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }

  Future<void> updateExprationDateForIngredient(
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
  }

  Future<bool> addIngredient(Ingredient ingredient) async {
    PantryIngredient pantryIngredient = PantryIngredient(
      ownerId: supabase.auth.currentUser!.id,
      addedOn: DateTime.now().toIso8601String(),
      expiresOn: DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      ingredient: ingredient,
    );
    state = [
      ...[pantryIngredient],
      ...state
    ];

    final pantryIngredientJson = pantryIngredient.toJson();
    pantryIngredientJson.removeWhere((key, value) => key == 'id');

    final success = await DB.updateIngredientInPantry(pantryIngredientJson);
    return success;
  }

  Future<bool> removeIngredientAtIndex(int index) async {
    final ingredient = state[index];

    state = state.where((i) => i != ingredient).toList();

    final success = await DB.removeIngredientFromPantry(ingredient.id!);
    return success;
  }
}
