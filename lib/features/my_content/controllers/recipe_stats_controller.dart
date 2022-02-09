import 'package:bodai/data/xdata.dart';
import 'package:bodai/features/my_content/controllers/all_my_recipes_controller.dart';
import 'package:bodai/models/meal_history_item.dart';
import 'package:bodai/models/plan_item.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeStatsProvider =
    StateNotifierProvider<RecipeStatsController, Map<int, RecipeStats>>(
        (ref) => RecipeStatsController(ref: ref));

class RecipeStatsController extends StateNotifier<Map<int, RecipeStats>> {
  RecipeStatsController({required this.ref}) : super({});

  final Ref ref;

  Future<void> load() async {
    if (supabase.auth.currentUser != null) {
      var usersJson = await DB.getAllUsers();
      var plansJson = await DB.getAllMealsInPlans();
      var cookedJson = await DB.getAllCookedMeals();

      state.clear();

      List<int> myRecipeIDs = [];

      for (var recipe in ref.read(allRecipesProvider)) {
        myRecipeIDs.add(recipe.id);
      }

      for (var recipeID in myRecipeIDs) {
        state[recipeID] = RecipeStats(
            inNumCookbooks: 0, inNumOfPlans: 0, numLikes: 0, numDislikes: 0);
      }

      List<int> planItems = [];
      for (var planJson in plansJson) {
        var planItem = PlanItem.fromJson(planJson);
        planItems.add(planItem.mealID);
      }

      for (var recipe in planItems) {
        if (state.containsKey(recipe)) {
          var inNumOfPlans = state[recipe]?.inNumOfPlans ?? 0;
          state[recipe] =
              state[recipe]!.copyWith(inNumOfPlans: inNumOfPlans + 1);
        }
      }

      List<int> cookedItems = [];
      for (var cookJson in cookedJson) {
        var cookedItem = MealHistoryItem.fromJson(cookJson);
        cookedItems.add(cookedItem.recipeID);
      }

      for (var like in cookedItems) {
        if (state.containsKey(like)) {
          var numLikes = state[like]?.numLikes ?? 0;
          state[like] = state[like]!.copyWith(numLikes: numLikes + 1);
        }
      }

      for (var json in usersJson) {
        var user = User.fromJson(json);

        for (var recipe in user.recipesLiked.toSet()) {
          if (state.containsKey(recipe)) {
            var inNumCookbooks = state[recipe]?.inNumCookbooks ?? 0;
            state[recipe] =
                state[recipe]!.copyWith(inNumCookbooks: inNumCookbooks + 1);
          }
        }

        for (var dislike in user.recipesDisliked) {
          if (state.containsKey(dislike)) {
            var numDislikes = state[dislike]?.numDislikes ?? 0;
            state[dislike] =
                state[dislike]!.copyWith(numDislikes: numDislikes + 1);
          }
        }
      }
    }
  }
}
