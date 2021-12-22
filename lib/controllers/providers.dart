import 'package:bindl/controllers/meal_plan_controller.dart';
import 'package:bindl/controllers/shopping_list_controller.dart';
import 'package:bindl/controllers/settings_controller.dart';
import 'package:bindl/controllers/sign_in_controller.dart';
import 'package:bindl/controllers/survey_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_controller.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

final userProvider = ChangeNotifierProvider((ref) => UserController());

final signInProvider = ChangeNotifierProvider((ref) => SignInController());

final mealPlanProvider = ChangeNotifierProvider((ref) => MealPlanController());
final shoppingListProvider =
    ChangeNotifierProvider((ref) => ShoppingListController(ref));

final settingsProvider = ChangeNotifierProvider((ref) => SettingsController());
