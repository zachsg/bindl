import 'package:bindl/bindl_theme.dart';
import 'package:bindl/meal_plan/meal_plan_details_view.dart';
import 'package:bindl/meal_plan/meal_plan_view.dart';
import 'package:bindl/shared/db.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/sign_in/sign_in_view.dart';
import 'package:bindl/survey/survey_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings/settings_view.dart';

class BindlApp extends ConsumerWidget {
  const BindlApp({
    Key? key,
  }) : super(key: key);

  Future<bool> _loadSettings(WidgetRef ref) async {
    await ref.read(settingsProvider).loadSettings();
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _loadSettings(ref),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('Send help!');
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return AnimatedBuilder(
                animation: ref.read(settingsProvider),
                builder: (BuildContext context, Widget? child) {
                  return MaterialApp(
                    restorationScopeId: 'app',
                    theme: BindlTheme.light(),
                    darkTheme: BindlTheme.dark(),
                    themeMode: ref.read(settingsProvider).themeMode,
                    onGenerateRoute: (RouteSettings routeSettings) {
                      return MaterialPageRoute<void>(
                        settings: routeSettings,
                        builder: (BuildContext context2) {
                          switch (routeSettings.name) {
                            case SurveyView.routeName:
                              return const SurveyView();
                            case SignInView.routeName:
                              return const SignInView();
                            case SettingsView.routeName:
                              return SettingsView();
                            case MealPlanDetailsView.routeName:
                              return MealPlanDetailsView(
                                id: routeSettings.arguments as int,
                              );
                            case MealPlanView.routeName:
                              return const MealPlanView();
                            default:
                              return supabase.auth.currentUser != null
                                  ? const MealPlanView()
                                  : ref.read(settingsProvider).surveyIsDone
                                      ? const SignInView()
                                      : const SurveyView();
                          }
                        },
                      );
                    },
                  );
                },
              );
            }
        }
      },
    );
  }
}
