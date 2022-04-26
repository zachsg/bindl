import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../features/discover_recipes/discover_recipes_controller.dart';
import '../models/xmodels.dart';
import 'user_controller.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final ingredientQuantityProvider = StateProvider<double>((ref) => 0.0);

final ingredientMeasureProvider =
    StateProvider<IngredientMeasure>((ref) => IngredientMeasure.oz);

final didOnboardingProvider = StateProvider<bool>((ref) => true);

final pantryTabIndexProvider = StateProvider<int>((ref) => 0);

final addIngredientProvider = StateProvider<Ingredient>((ref) =>
    const Ingredient(id: -1, name: '', category: IngredientCategory.misc));

final expiresOnProvider = StateProvider<DateTime>((ref) => DateTime.now());

final loadingNewIngredientProvider = StateProvider<bool>((ref) => false);

final bottomNavProvider = StateProvider<int>((_) => 0);

final tabLabelProvider = StateProvider<String>((ref) {
  switch (ref.watch(bottomNavProvider)) {
    case 0:
      return 'Pantry';
    case 1:
      return 'Recipes';
    case 2:
      return 'Profile';
    default:
      return 'Pantry';
  }
});

final mealStepExpandedProvider = StateProvider<bool>((_) => false);

final isMealDetailsLoadingProvider = StateProvider<bool>((_) => false);

final ownsAllIngredientsProvider = StateProvider<bool>((ref) => false);

final hasAllIngredientsInFridgeProvider = StateProvider<bool>((ref) => false);

final filterFeedByProvider = StateProvider<int>((ref) => 0);

final onboardingPageNumberProvider = StateProvider<int>((ref) => 0);

final loadingAvatarProvider = StateProvider<bool>((ref) => false);

final systemInfoFutureProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

final currentProfileTabProvider = StateProvider<int>((ref) => 0);

final recipeQuantityProvider = StateProvider<double>((ref) => 0.0);

final recipeIngredientProvider = StateProvider<Ingredient>((ref) =>
    const Ingredient(id: -1, name: '', category: IngredientCategory.oils));

final recipeMeasureProvider =
    StateProvider<IngredientMeasure>((ref) => IngredientMeasure.oz);

final recipePreparationMethodProvider = StateProvider<String>((ref) => '');

final recipeIngredientIsOptionalProvider = StateProvider<bool>((ref) => false);

final recipeNeedsSavingProvider = StateProvider<bool>((ref) => false);

final iAmFollowingProvider = StateProvider<bool>((ref) => false);

final currentYourProfileTabProvider = StateProvider<int>((ref) => 0);

// TODO: Set otherUserIdProvider whenever navigating to another user's profile
final otherUserIdProvider = StateProvider<String>((ref) => '');

final followerFollowingIdsProvider = StateProvider<List<String>>((ref) => []);

final usersFutureProvider = FutureProvider<List<User>>((ref) {
  return ref
      .watch(userProvider.notifier)
      .loadUsersWithIds(ref.watch(followerFollowingIdsProvider));
});
