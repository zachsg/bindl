import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cookbook_controller.dart';

final ingredientsSearchProvider =
    StateNotifierProvider<IngredientsSearchController, List<String>>(
        (ref) => IngredientsSearchController(ref: ref));

class IngredientsSearchController extends StateNotifier<List<String>> {
  IngredientsSearchController({required this.ref}) : super([]);

  final Ref ref;

  void clearIngredientsToUse() {
    state = [];
  }

  void setIngredientToUse(String ingredient) {
    state = [...state, ingredient.toLowerCase().trim()];

    ref.read(cookbookProvider.notifier).load();
  }

  void removeIngredientToUse(String ingredient) {
    state = state
        .where(((element) => element != ingredient.toLowerCase().trim()))
        .toList();

    ref.read(cookbookProvider.notifier).load();
  }
}