import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';

class SurveyController extends ChangeNotifier {
  final _allSurveyMeals = SurveyMeals.all;

  get allMeals => _allSurveyMeals;

  bool mealsEmpty() => _allSurveyMeals.isEmpty;

  void addMeals(List<SurveyMeal> meals) {
    _allSurveyMeals.addAll(meals);

    notifyListeners();
  }

  void removeMealAtIndex(int index) {
    _allSurveyMeals.removeAt(index);

    notifyListeners();
  }
}
