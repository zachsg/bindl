import 'package:bindl/bindl_theme.dart';
import 'package:bindl/meal_plan/meal_plan_details_view.dart';
import 'package:bindl/meal_plan/meal_plan_view.dart';
import 'package:bindl/sign_in/sign_in_view.dart';
import 'package:bindl/survey/survey_view.dart';
import 'package:bindl/utils/constants.dart';
import 'package:flutter/material.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class BindlApp extends StatelessWidget {
  const BindlApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          theme: BindlTheme.light(),
          darkTheme: BindlTheme.dark(),
          themeMode: settingsController.themeMode,
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
                      mealJson: routeSettings.arguments as Map<String, dynamic>,
                    );
                  case MealPlanView.routeName:
                    return const MealPlanView();
                  default:
                    return supabase.auth.currentUser != null
                        ? const MealPlanView()
                        : settingsController.surveyIsDone
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
