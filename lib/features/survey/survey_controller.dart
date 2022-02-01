import 'package:bodai/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

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
