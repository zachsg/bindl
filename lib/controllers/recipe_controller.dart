import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';

class RecipeController extends ChangeNotifier {
  int _id = 0;
  String _name = '';
  List<Ingredient> _ingredients = [];
  List<String> _steps = [];
  int _servings = 2;
  int _duration = 25;
  String _imageURL = '';

  final List<Meal> _allMyRecipes = [];

  int get id => _id;

  String get name => _name;

  List<Ingredient> get ingredients => _ingredients;

  List<String> get steps => _steps;

  int get servings => _servings;

  int get duration => _duration;

  String get imageURL => _imageURL;

  List<Meal> get allMyRecipes => _allMyRecipes;

  void setID(int id) {
    _id = id;

    notifyListeners();
  }

  void setName(String name) {
    _name = name;

    notifyListeners();
  }

  void setImageURL(String url) {
    _imageURL = url;

    notifyListeners();
  }

  void setServings(int servings) {
    _servings = servings;

    notifyListeners();
  }

  void setDuration(int duration) {
    _duration = duration;

    notifyListeners();
  }

  void addIngredient(Ingredient ingredient) {
    _ingredients.add(ingredient);

    notifyListeners();
  }

  Ingredient removeIngredientAtIndex(int index) {
    var ingredient = _ingredients.removeAt(index);

    notifyListeners();

    return ingredient;
  }

  void addStep(String step) {
    _steps.add(step);

    notifyListeners();
  }

  String removeStepAtIndex(int index) {
    final step = _steps.removeAt(index);

    notifyListeners();

    return step;
  }

  void insertStepAtIndex(int index, String step) {
    _steps.insert(index, step);

    notifyListeners();
  }

  Future<String> validateAndSave() async {
    if (_name.isEmpty) {
      return 'Recipe name cannot be empty';
    }

    if (_steps.isEmpty) {
      return 'Steps cannot be empty';
    }

    if (_ingredients.isEmpty) {
      return 'Ingredients cannot be empty';
    }

    if (_imageURL.isEmpty) {
      return 'Image cannot be empty';
    }

    if (DB.currentUser != null) {
      var owner = DB.currentUser!.id;

      var recipe = Meal(_id, owner, _name, _servings, _duration, _imageURL,
          _steps, _ingredients, [], []);

      var recipeJSON = recipe.toJson();

      await DB.saveRecipe(recipeJSON);

      notifyListeners();

      return 'success';
    } else {
      return 'User is not logged in';
    }
  }

  Future<List<Meal>> allMeals() async {
    var mealsJson = await DB.loadAllMeals();

    List<Meal> meals = [];
    for (var json in mealsJson) {
      var meal = Meal.fromJson(json);
      meals.add(meal);
    }

    return meals;
  }

  Future<void> loadAllMyRecipes() async {
    if (DB.currentUser != null) {
      var recipesJson = await DB.loadAllMealsOwnedBy(DB.currentUser!.id);

      _allMyRecipes.clear();

      for (var json in recipesJson) {
        var recipe = Meal.fromJson(json);
        _allMyRecipes.add(recipe);
      }

      notifyListeners();
    }
  }

  void setupSelf(Meal meal) {
    _id = meal.id;
    _name = meal.name;
    _servings = meal.servings;
    _duration = meal.duration;
    _imageURL = meal.imageURL;
    _ingredients = meal.ingredients;
    _steps = meal.steps;
  }

  void resetSelf() {
    _id = 0;
    _name = '';
    _servings = 2;
    _duration = 25;
    _imageURL = '';
    _ingredients = [];
    _steps = [];
  }
}
