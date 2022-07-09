import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../../providers/providers.dart';
import '../../../services/db.dart';

final yourRecipesProvider =
    StateNotifierProvider<YourRecipesController, List<Recipe>>(
        (ref) => YourRecipesController(ref: ref));

class YourRecipesController extends StateNotifier<List<Recipe>> {
  YourRecipesController({required this.ref}) : super([]);

  final Ref ref;

  Future<bool> load() async {
    ref.read(loadingProvider.notifier).state = true;

    state.clear();

    final response = await DB.loadYourRecipes(ref.watch(otherUserIdProvider));

    if (response != null) {
      for (final recipeJson in response) {
        state = [...state, Recipe.fromJson(recipeJson)];
      }
    }

    state.removeWhere((recipe) => recipe.imageUrl.isEmpty);

    ref.read(loadingProvider.notifier).state = false;

    return true;
  }
}
