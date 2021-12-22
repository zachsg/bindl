import 'package:bindl/models/models.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  static const String themeKey = 'theme';
  static const String surveyIsDoneKey = 'survey';
  bool _surveyIsDone = false;
  PackageInfo? _packageInfo;

  String get appVersion => _packageInfo?.version ?? '';
  String get appBuildNumber => _packageInfo?.buildNumber ?? '';

  bool get surveyIsDone => _surveyIsDone;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _packageInfo = await PackageInfo.fromPlatform();

    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(surveyIsDoneKey)) {
      _surveyIsDone = prefs.getBool(surveyIsDoneKey) ?? false;
    }

    if (prefs.containsKey(themeKey)) {
      var themeModeIndex = prefs.getInt(themeKey) ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
    }

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(themeKey, ThemeMode.values.indexOf(newThemeMode));
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
    final success = await DB.signOut();

    return success;
  }
}
