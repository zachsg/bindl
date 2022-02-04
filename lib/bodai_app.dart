import 'package:bodai/bodai_theme.dart';
import 'package:bodai/data/auth.dart';
import 'package:bodai/features/my_content/views/my_recipe_details_view.dart';
import 'package:bodai/features/my_content/views/my_recipes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/bottom_nav_view.dart';
import 'features/settings/settings_controller.dart';
import 'features/settings/settings_view.dart';
import 'features/sign_in/sign_in_view.dart';
import 'features/sign_in/sign_up_view.dart';
import 'features/survey/survey_view.dart';
import 'shared_widgets/xwidgets.dart';

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
    ref.read(settingsProvider.notifier).loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
              case MealDetailsView.routeName:
                return MealDetailsView(
                  id: routeSettings.arguments as int,
                );
              case BottomNavView.routeName:
                return const BottomNavView();
              case MyRecipesView.routeName:
                return const MyRecipesView();
              case MyRecipeDetailsView.routeName:
                return const MyRecipeDetailsView();
              default:
                return Auth.isLoggedIn
                    ? const BottomNavView()
                    : ref.watch(settingsProvider).surveyIsDone
                        ? const SignInView()
                        : const SurveyView();
            }
          },
        );
      },
    );
  }
}
