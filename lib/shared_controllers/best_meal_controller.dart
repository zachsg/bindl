import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/features/meal_plan/meal_plan_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BestMealController extends StateNotifier<Meal> {
  BestMealController({required this.ref})
      : super(const Meal(
          id: -1,
          owner: '',
          name: '',
          servings: 1,
          duration: 10,
          imageURL: '',
          steps: [],
          ingredients: [],
          tags: [],
          allergies: [],
          comments: [],
        ));

  final Ref ref;

  void compute() {
    const fakeMeal = Meal(
      id: -1,
      owner: '',
      name: '',
      servings: 1,
      duration: 10,
      imageURL: '',
      steps: [],
      ingredients: [],
      tags: [],
      allergies: [],
      comments: [],
    );

    state = ref.read(userProvider).bestMeal() ?? fakeMeal;
  }

  Future<void> undoSwipe(Meal meal) async {
    await ref.read(userProvider).setRating(meal.id, meal.tags, Rating.neutral);

    ref.read(mealPlanProvider).load();

    compute();
  }
}