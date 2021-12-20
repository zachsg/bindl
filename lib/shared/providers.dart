import 'package:bindl/meal_plan/meal_plan_controller.dart';
import 'package:bindl/meal_plan/shopping_list_controller.dart';
import 'package:bindl/settings/settings_controller.dart';
import 'package:bindl/sign_in/sign_in_controller.dart';
import 'package:bindl/survey/survey_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_controller.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

final userProvider = ChangeNotifierProvider((ref) => UserController());

final signInProvider = ChangeNotifierProvider((ref) => SignInController());

final mealPlanProvider = ChangeNotifierProvider((ref) => MealPlanController());
final shoppingListProvider =
    ChangeNotifierProvider((ref) => ShoppingListController());

final settingsProvider = ChangeNotifierProvider((ref) => SettingsController());
