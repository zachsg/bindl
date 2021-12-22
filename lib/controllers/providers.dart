import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

final userProvider = ChangeNotifierProvider((ref) => UserController());

final signInProvider = ChangeNotifierProvider((ref) => SignInController());

final mealPlanProvider = ChangeNotifierProvider((ref) => MealPlanController());

final shoppingListProvider =
    ChangeNotifierProvider((ref) => ShoppingListController(ref));

final settingsProvider = ChangeNotifierProvider((ref) => SettingsController());
