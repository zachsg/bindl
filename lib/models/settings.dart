import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class Settings {
  static const String themeKey = 'theme';
  static const String surveyIsDoneKey = 'survey';

  final ThemeMode themeMode;
  final bool surveyIsDone;
  final PackageInfo packageInfo;

  Settings({
    required this.themeMode,
    required this.surveyIsDone,
    required this.packageInfo,
  });

  Settings copyWith({
    ThemeMode? themeMode,
    bool? surveyIsDone,
    PackageInfo? packageInfo,
  }) =>
      Settings(
        themeMode: themeMode ?? this.themeMode,
        surveyIsDone: surveyIsDone ?? this.surveyIsDone,
        packageInfo: packageInfo ?? this.packageInfo,
      );
}
