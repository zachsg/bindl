import 'package:bodai/controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealHistoryController extends StateNotifier<List<Meal>> {
  MealHistoryController({required this.ref}) : super([]);

  final Ref ref;

  void load() async {
    state.clear();

    var liked = ref.read(userProvider).recipesLiked;
    var disliked = ref.read(userProvider).recipesDisliked;

    var ids = liked; // + disliked;

    for (var meal in ref.read(mealsProvider)) {
      if (ids.contains(meal.id)) {
        state.add(meal);
      }
    }
  }

  void add(Meal meal) {
    var alreadyCooked = false;

    for (var m in state) {
      if (m.id == meal.id) {
        alreadyCooked = true;
        break;
      }
    }

    if (!alreadyCooked) {
      state.insert(0, meal);
    }
  }

  Meal mealForID(int id) {
    Meal meal = const Meal(
      id: 0,
      owner: '',
      name: '',
      servings: 0,
      duration: 0,
      imageURL: '',
      steps: [],
      ingredients: [],
      tags: [],
      allergies: [],
      comments: [],
    );

    for (var m in state) {
      if (m.id == id) {
        meal = m;
        break;
      }
    }

    return meal;
  }
}
