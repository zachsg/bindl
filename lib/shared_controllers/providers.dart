import 'package:bodai/shared_controllers/best_meal_controller.dart';
import 'package:bodai/shared_controllers/meals_controller.dart';
import 'package:bodai/shared_controllers/user_controller.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserController, User>(
    (ref) => UserController(ref: ref));

final bestMealProvider = StateNotifierProvider<BestMealController, Meal>(
    (ref) => BestMealController(ref: ref));

final mealsProvider = StateNotifierProvider<MealsController, List<Meal>>(
    (ref) => MealsController(ref: ref));

final bottomNavProvider = StateProvider<int>((_) => 1);
