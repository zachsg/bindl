import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/xdata.dart';
import '../../../models/xmodels.dart';

final allRecipesProvider =
    StateNotifierProvider<AllMyRecipesController, List<Meal>>(
        (_) => AllMyRecipesController());

class AllMyRecipesController extends StateNotifier<List<Meal>> {
  AllMyRecipesController() : super([]);

  Future<void> load() async {
    if (supabase.auth.currentUser != null) {
      var recipesJson =
          await DB.loadAllMealsOwnedBy(supabase.auth.currentUser!.id);

      state.clear();

      for (var json in recipesJson) {
        var recipe = Meal.fromJson(json);
        state = [...state, recipe];
      }
    }
  }
}
