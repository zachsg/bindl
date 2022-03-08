import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/recipe.dart';
import '../../providers/providers.dart';
import '../../services/db.dart';

final myRecipesProvider =
    StateNotifierProvider<MyRecipesController, List<Recipe>>(
        (ref) => MyRecipesController(ref: ref));

class MyRecipesController extends StateNotifier<List<Recipe>> {
  MyRecipesController({required this.ref}) : super([]);

  final Ref ref;

  Future<bool> load() async {
    ref.read(loadingProvider.notifier).state = true;

    state.clear();

    final response = await DB.loadMyRecipes();

    if (response != null) {
      for (final recipeJson in response) {
        state = [...state, Recipe.fromJson(recipeJson)];
      }
    }

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }
}
