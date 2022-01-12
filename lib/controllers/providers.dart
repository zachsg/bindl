import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'xcontrollers.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

final userProvider = ChangeNotifierProvider((ref) => UserController(ref: ref));

final signInProvider = ChangeNotifierProvider((ref) => SignInController());

final mealPlanProvider =
    ChangeNotifierProvider((ref) => MealPlanController(ref: ref));

final mealHistoryProvider =
    StateNotifierProvider<MealHistoryController, List<Meal>>(
        (ref) => MealHistoryController(ref: ref));

final mealsProvider = StateNotifierProvider<MealsController, List<Meal>>(
    (ref) => MealsController());

final shoppingListProvider =
    ChangeNotifierProvider((ref) => ShoppingListController());

final pantryProvider = ChangeNotifierProvider((ref) => PantryController());

final recipeProvider = ChangeNotifierProvider((ref) => RecipeController());

final bottomNavProvider = StateProvider<int>((_) => 0);

final opacityProvider = StateProvider<double>((_) => 1.0);

final settingsProvider = StateNotifierProvider<SettingsController, Settings>(
    (ref) => SettingsController());
