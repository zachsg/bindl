import 'package:bindl/survey/survey_meal.dart';
import 'package:bindl/utils/constants.dart';
import 'package:flutter/material.dart';

class SurveyContoller extends ChangeNotifier {
  final _allSurveyMeals = allSurveyMeals;

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
