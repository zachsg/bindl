import 'package:bodai/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

class SurveyController extends ChangeNotifier {
  List<SurveyMeal> _all = SurveyMeals.all;

  List<SurveyMeal> get all => _all;

  void removeAtIndex(int index) {
    _all.removeAt(index);
    notifyListeners();
  }
}
