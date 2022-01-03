import 'package:bodai/bodai_theme.dart';
import 'package:bodai/screens/my_content/my_recipe_details_view.dart';
import 'package:bodai/screens/my_content/my_recipes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/xcontrollers.dart';
import 'models/xmodels.dart';
import 'screens/meal_plan/meal_plan_details_view.dart';
import 'screens/meal_plan/meal_plan_view.dart';
import 'screens/settings/settings_view.dart';
import 'screens/sign_in/sign_in_view.dart';
import 'screens/sign_in/sign_up_view.dart';
import 'screens/survey/survey_view.dart';

class BodaiApp extends ConsumerStatefulWidget {
  const BodaiApp({
    Key? key,
  }) : super(key: key);

  @override
  _BodaiApp createState() => _BodaiApp();
}

class _BodaiApp extends ConsumerState<BodaiApp> {
  @override
  void initState() {
    super.initState();
    ref.read(settingsProvider).loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ref.watch(settingsProvider),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          theme: BodaiTheme.light(),
          darkTheme: BodaiTheme.dark(),
          themeMode: ref.watch(settingsProvider).themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context2) {
                switch (routeSettings.name) {
                  case SurveyView.routeName:
                    return const SurveyView();
                  case SignUpView.routeName:
                    return const SignUpView();
                  case SignInView.routeName:
                    return const SignInView();
                  case SettingsView.routeName:
                    return const SettingsView();
                  case MealPlanDetailsView.routeName:
                    return MealPlanDetailsView(
                      id: routeSettings.arguments as int,
                    );
                  case MealPlanView.routeName:
                    return const MealPlanView();
                  case MyRecipesView.routeName:
                    return const MyRecipesView();
                  case MyRecipeDetailsView.routeName:
                    return const MyRecipeDetailsView();
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
