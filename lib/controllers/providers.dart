import 'package:bodai/controllers/best_meal_controller.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'xcontrollers.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

final userProvider = ChangeNotifierProvider((ref) => UserController(ref: ref));

final signInProvider = ChangeNotifierProvider((ref) => SignInController());

final bestMealProvider = StateNotifierProvider<BestMealController, Meal>(
    (ref) => BestMealController(ref: ref));

final mealPlanProvider =
    ChangeNotifierProvider((ref) => MealPlanController(ref: ref));

final cookbookProvider =
    ChangeNotifierProvider((ref) => CookbookController(ref: ref));

final mealsProvider = StateNotifierProvider<MealsController, List<Meal>>(
    (ref) => MealsController(ref: ref));

final shoppingListProvider =
    ChangeNotifierProvider((ref) => ShoppingListController(ref: ref));

final pantryProvider = ChangeNotifierProvider((ref) => PantryController());

final recipeProvider = ChangeNotifierProvider((ref) => RecipeController());

final bottomNavProvider = StateProvider<int>((_) => 1);

final consecutiveSwipesProvider = StateProvider<int>((_) => 0);

final swipeIsLikeProvider = StateProvider<bool>((_) => false);

final wasJustDismissedProvider = StateProvider<bool>((_) => false);

final opacityProvider = StateProvider<double>((_) => 1.0);

final myCookbookIsCollapsedProvider = StateProvider<bool>((_) => false);

final myRecipesAreCollapsedProvider = StateProvider<bool>((_) => false);

final settingsProvider = StateNotifierProvider<SettingsController, Settings>(
    (ref) => SettingsController());
