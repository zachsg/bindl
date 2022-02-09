import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/data/xdata.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/features/cookbook/controllers/cookbook_controller.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/meal_plan/controllers/pantry_controller.dart';

class UserController extends StateNotifier<User> {
  UserController({required this.ref})
      : super(User(
          id: '',
          updatedAt: DateTime.now().toIso8601String(),
          name: '',
          tags: {},
          allergies: {
            Allergy.soy: false,
            Allergy.gluten: false,
            Allergy.dairy: false,
            Allergy.egg: false,
            Allergy.shellfish: false,
            Allergy.sesame: false,
            Allergy.treeNuts: false,
            Allergy.peanuts: false,
            Allergy.meat: false,
            Allergy.seafood: false,
          },
          adoreIngredients: [],
          abhorIngredients: [],
          recipesLiked: [],
          recipesDisliked: [],
          servings: 2,
          numMeals: 2,
          pantry: [],
        ));

  final Ref ref;

  int getRating(int id) {
    if (state.recipesLiked.contains(id)) {
      return Rating.values.indexOf(Rating.dislike);
    } else if (state.recipesDisliked.contains(id)) {
      return Rating.values.indexOf(Rating.like);
    } else {
      return Rating.values.indexOf(Rating.neutral);
    }
  }

  Future<void> setAllergy(
      {required Allergy allergy,
      bool isAllergic = true,
      bool shouldPersist = false}) async {
    state.allergies[allergy] = isAllergic;

    state = state.copyWith(allergies: state.allergies);

    if (shouldPersist) {
      await _persistChangesAndCompute();
    }
  }

  Future<void> _persistChangesAndCompute() async {
    await save();
    ref.read(bestMealProvider.notifier).compute();
  }

  bool isAllergic(Allergy allergy) {
    return state.allergies[allergy] ?? false;
  }

  Future<void> setAdoreIngredient(
      {required String ingredient,
      required bool isAdore,
      bool shouldPersist = false}) async {
    if (isAdore) {
      state = state
          .copyWith(adoreIngredients: [...state.adoreIngredients, ingredient]);
    } else {
      state.adoreIngredients.removeWhere((element) => element == ingredient);
      state = state.copyWith(adoreIngredients: state.adoreIngredients);
    }

    if (shouldPersist) {
      await _persistChangesAndCompute();
    }
  }

  Future<void> setAbhorIngredient(
      {required String ingredient,
      required isAbhor,
      bool shouldPersist = false}) async {
    if (isAbhor) {
      state = state
          .copyWith(abhorIngredients: [...state.abhorIngredients, ingredient]);
    } else {
      state.abhorIngredients.removeWhere((element) => element == ingredient);
      state = state.copyWith(abhorIngredients: state.abhorIngredients);
    }

    if (shouldPersist) {
      await _persistChangesAndCompute();
    }
  }

  Future<void> setHasAccount(bool hasAccount) async {
    state = state.copyWith(hasAccount: hasAccount);
    await save();
  }

  void addTags(List<Tag> tags, bool isLike) {
    for (var tag in tags) {
      if (isLike) {
        if (state.tags.containsKey(tag)) {
          state.tags[tag] = state.tags[tag]! + 1;
          state = state.copyWith(tags: state.tags);
        } else {
          state.tags[tag] = 1;
          state = state.copyWith(tags: state.tags);
        }
      } else {
        if (state.tags.containsKey(tag)) {
          state.tags[tag] = state.tags[tag]! - 1;
          state = state.copyWith(tags: state.tags);
        } else {
          state.tags[tag] = -1;
          state = state.copyWith(tags: state.tags);
        }
      }
    }
  }

  Future<void> load() async {
    if (supabase.auth.currentUser != null) {
      final data = await DB.loadUserData();

      try {
        state = User.fromJson(data);
        ref.read(bestMealProvider.notifier).compute();
      } catch (e) {
        // await Auth.signOut();
      }
    }
  }

  Future<bool> updateDisplayName(String displayName) async {
    if (supabase.auth.currentUser != null) {
      state = state.copyWith(name: displayName);
      var saved = await save();

      return saved;
    }

    return false;
  }

  Future<bool> save() async {
    if (supabase.auth.currentUser != null) {
      state = state.copyWith(id: supabase.auth.currentUser!.id);

      if (state.name.isEmpty) {
        state = state.copyWith(
            name: supabase.auth.currentUser!.email?.split('@').first ?? 'anon');
      }

      state = state.copyWith(updatedAt: DateTime.now().toIso8601String());
      final userJSON = state.toJson();

      final success = await DB.saveUserData(userJSON);

      if (success) {
        return true;
      } else {
        return false;
      }
    } else {
      // TODO: Not authenticated, handle error
      return false;
    }
  }

  Future<void> addToCookbook(Meal meal) async {
    state.recipesLiked.add(meal.id);
    state = state.copyWith(recipesLiked: state.recipesLiked);

    await _setRating(meal.id, meal.tags, Rating.like, false);
  }

  Future<void> removeFromCookbook(Meal meal) async {
    state.recipesLiked.removeWhere((mealId) => meal.id == mealId);
    state = state.copyWith(recipesLiked: state.recipesLiked);

    await _setRating(meal.id, meal.tags, Rating.dislike, false);
  }

  Future<void> discard(Meal meal) async {
    if (!state.recipesDisliked.contains(meal.id)) {
      state.recipesDisliked.add(meal.id);
      state = state.copyWith(recipesDisliked: state.recipesDisliked);
    }

    await _setRating(meal.id, meal.tags, Rating.dislike, false);
  }

  Future<void> markCooked(Meal meal) async {
    var wasInMealPlan =
        ref.read(mealPlanProvider.notifier).containsMeal(meal.id);

    if (wasInMealPlan) {
      await ref.read(mealPlanProvider.notifier).removeFromMealPlan(meal);
    }

    await _setRating(meal.id, meal.tags, Rating.like, true);
    if (supabase.auth.currentUser != null) {
      await DB.markCooked(supabase.auth.currentUser!.id, meal.id);
    }

    if (ref.read(mealPlanProvider).isEmpty) {
      ref.read(pantryProvider.notifier).clear();
      ref.read(bottomNavProvider.notifier).state = 1;
    }
  }

  Future<void> undoRating(Meal meal) async {
    if (state.recipesLiked.contains(meal.id)) {
      state.recipesLiked.removeWhere((mealId) => meal.id == mealId);
      state = state.copyWith(recipesLiked: state.recipesLiked);
    } else if (state.recipesDisliked.contains(meal.id)) {
      state.recipesDisliked.removeWhere((mealId) => meal.id == mealId);
      state = state.copyWith(recipesDisliked: state.recipesDisliked);
    }
    await _setRating(meal.id, meal.tags, Rating.neutral, false);
  }

  Future<void> _setRating(
      int id, List<Tag> tags, Rating rating, bool isMarkedDone) async {
    if (supabase.auth.currentUser != null) {
      switch (rating) {
        case Rating.like:
          await DB.setRatings(
              supabase.auth.currentUser!.id, state.recipesLiked, true);

          addTags(tags, true);
          await save();
          break;
        case Rating.dislike:
          await DB.setRatings(
              supabase.auth.currentUser!.id, state.recipesDisliked, false);
          addTags(tags, false);
          await save();
          break;
        case Rating.neutral:
          await DB.setRatings(
              supabase.auth.currentUser!.id, state.recipesDisliked, false);
          await save();
          break;
        default:
      }

      await ref.read(mealPlanProvider.notifier).load();
      ref.read(cookbookProvider.notifier).load();
      ref.read(bestMealProvider.notifier).compute();
    }
  }

  Future<void> setServings(int servings) async {
    if (supabase.auth.currentUser != null) {
      final success =
          await DB.setServings(supabase.auth.currentUser!.id, servings);

      if (success) {
        state = state.copyWith(servings: servings);
      }
    }
  }

  Future<void> setNumMeals(int numMeals) async {
    if (supabase.auth.currentUser != null) {
      final success =
          await DB.setNumMeals(supabase.auth.currentUser!.id, numMeals);

      if (success) {
        state = state.copyWith(numMeals: numMeals);
      }
    }
  }
}
