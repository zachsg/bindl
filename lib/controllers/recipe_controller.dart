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

  void addStep(String step) {
    _steps.add(step);

    notifyListeners();
  }
}
