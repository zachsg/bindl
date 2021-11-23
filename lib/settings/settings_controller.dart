import 'package:bindl/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets.
class SettingsController extends ChangeNotifier {
  static const String surveyIsDoneKey = 'survey';
  bool _surveyIsDone = false;

  bool get surveyIsDone => _surveyIsDone;

  ThemeMode _themeMode = ThemeMode.system;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  /// Load the user's settings. May load from local database or internet.
  /// The controller only knows it can load the settings from the service.
  Future<void> loadSettings() async {
    _themeMode = ThemeMode.system;

    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(surveyIsDoneKey)) {
      _surveyIsDone = prefs.getBool(surveyIsDoneKey) ?? false;
    }

    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();
  }

  Future<void> completeSurvey(bool surveyIsDone) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(surveyIsDoneKey, surveyIsDone);
    _surveyIsDone = surveyIsDone;
    notifyListeners();
  }

  Future<bool> signOut() async {
    final response = await supabase.auth.signOut();

    if (response.error == null) {
      return true;
    } else {
      return false;
    }
  }
}
