import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'xcontrollers.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

final userProvider = ChangeNotifierProvider((ref) => UserController());

final signInProvider = ChangeNotifierProvider((ref) => SignInController());

final mealPlanProvider = ChangeNotifierProvider((ref) => MealPlanController());

final shoppingListProvider =
    ChangeNotifierProvider((ref) => ShoppingListController());

final recipeProvider = ChangeNotifierProvider((ref) => RecipeController());

final bottomNavProvider = StateProvider<int>((_) => 0);

final settingsProvider = ChangeNotifierProvider((ref) => SettingsController());
