import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends StateNotifier<Settings> {
  SettingsController()
      : super(Settings(
          themeMode: ThemeMode.system,
          surveyIsDone: false,
          packageInfo: PackageInfo(
            appName: '',
            packageName: '',
            version: '',
            buildNumber: '',
          ),
        ));

  Future<void> loadSettings() async {
    var packageInfo = await PackageInfo.fromPlatform();
    state = state.copyWith(packageInfo: packageInfo);

    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Settings.surveyIsDoneKey)) {
      var surveyIsDone = prefs.getBool(Settings.surveyIsDoneKey) ?? false;
      state = state.copyWith(surveyIsDone: surveyIsDone);
    }

    if (prefs.containsKey(Settings.themeKey)) {
      var themeModeIndex = prefs.getInt(Settings.themeKey) ?? 0;
      var themeMode = ThemeMode.values[themeModeIndex];
      state = state.copyWith(themeMode: themeMode);
    }
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == state.themeMode) return;

    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(Settings.themeKey, ThemeMode.values.indexOf(newThemeMode));
    state = state.copyWith(themeMode: newThemeMode);
  }

  Future<void> completeSurvey(bool surveyIsDone) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(Settings.surveyIsDoneKey, surveyIsDone);

    state = state.copyWith(surveyIsDone: surveyIsDone);
  }

  Future<bool> signOut() async {
    final success = await Auth.signOut();

    return success;
  }
}
