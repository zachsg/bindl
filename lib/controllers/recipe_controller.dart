import 'package:bindl/models/ingredient.dart';
import 'package:flutter/material.dart';

class RecipeController extends ChangeNotifier {
  final List<Ingredient> _ingredients = [];
  final List<String> _steps = [];

  List<Ingredient> get ingredients => _ingredients;

  List<String> get steps => _steps;

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
