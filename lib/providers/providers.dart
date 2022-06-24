import 'package:bodai/services/db.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/xmodels.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final ingredientQuantityProvider = StateProvider<double>((ref) => 0.0);

final ingredientMeasureProvider =
    StateProvider<IngredientMeasure>((ref) => IngredientMeasure.oz);

final didOnboardingProvider = StateProvider<bool>((ref) => true);

final pantryTabIndexProvider = StateProvider<int>((ref) => 0);

final ownsAllIngredientsProvider = StateProvider<bool>((ref) => false);

final hasAllIngredientsInFridgeProvider = StateProvider<bool>((ref) => false);

final filterFeedByProvider = StateProvider<int>((ref) => 0);

final recipeQuantityProvider = StateProvider<double>((ref) => 0.0);

final recipeIngredientProvider = StateProvider<Ingredient>((ref) =>
    const Ingredient(id: -1, name: '', category: IngredientCategory.oils));

final recipeMeasureProvider =
    StateProvider<IngredientMeasure>((ref) => IngredientMeasure.oz);

final recipePreparationMethodProvider = StateProvider<String>((ref) => '');

final recipeIngredientIsOptionalProvider = StateProvider<bool>((ref) => false);

final recipeNeedsSavingProvider = StateProvider<bool>((ref) => false);

final iAmFollowingProvider = StateProvider<bool>((ref) => false);

// TODO: Set otherUserIdProvider whenever navigating to another user's profile
final otherUserIdProvider = StateProvider<String>((ref) => '');

final followerFollowingIdsProvider = StateProvider<List<String>>((ref) => []);

final showingIngredientsButtonProvider = StateProvider<bool>((ref) => true);

final markCookedIsDirtyProvider = StateProvider<bool>((ref) => false);

final ingredientsExpiringSoonExpandedProvider =
    StateProvider<bool>((ref) => false);
