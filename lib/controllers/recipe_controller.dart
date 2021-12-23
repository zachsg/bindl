import 'package:bindl/models/ingredient.dart';
import 'package:flutter/material.dart';

class RecipeController extends ChangeNotifier {
  final List<Ingredient> _ingredients = [];
  final List<String> _steps = [];
  int _servings = 1;
  int _duration = 20;

  List<Ingredient> get ingredients => _ingredients;

  List<String> get steps => _steps;

  int get servings => _servings;

  int get duration => _duration;

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
}
