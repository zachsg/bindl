import 'package:bodai/controllers/best_meal_controller.dart';
import 'package:bodai/controllers/meals_controller.dart';
import 'package:bodai/controllers/user_controller.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = ChangeNotifierProvider((ref) => UserController(ref: ref));

final bestMealProvider = StateNotifierProvider<BestMealController, Meal>(
    (ref) => BestMealController(ref: ref));

final mealsProvider = StateNotifierProvider<MealsController, List<Meal>>(
    (ref) => MealsController(ref: ref));

final bottomNavProvider = StateProvider<int>((_) => 1);

final opacityProvider = StateProvider<double>((_) => 1.0);
