import 'package:bodai/features/auth/auth_view.dart';
import 'package:bodai/features/bottom_nav_view.dart';
import 'package:bodai/features/discover_recipes/discover_recipes_view.dart';
import 'package:bodai/features/discover_recipes/recipe_view.dart';
import 'package:bodai/features/onboarding/onboarding_view.dart';
import 'package:bodai/features/pantry/pantry_view.dart';
import 'package:bodai/features/profile/my_recipes/edit_recipe_view.dart';
import 'package:bodai/features/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/profile/my_profile/edit_profile_view.dart';
import 'features/profile/my_profile/my_profile_view.dart';
import 'features/profile/your_profile/your_profile_view.dart';
import 'providers/providers.dart';

class BodaiApp extends ConsumerStatefulWidget {
  const BodaiApp({super.key, required this.theme});

  final ThemeMode theme;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BodaiAppState();
}

class _BodaiAppState extends ConsumerState<BodaiApp> {
  @override
  void initState() {
    ref.read(themeProvider.notifier).state = widget.theme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      title: 'Bodai',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ref.watch(themeProvider),
      initialRoute: SplashView.routeName,
      routes: <String, WidgetBuilder>{
        AuthView.routeName: (_) => const AuthView(),
        BottomNavView.routeName: (_) => const BottomNavView(),
        OnboardingView.routeName: (_) => const OnboardingView(),
        PantryView.routeName: (_) => const PantryView(),
        DiscoverRecipesView.routeName: (_) => const DiscoverRecipesView(),
        RecipeView.routeName: (_) => RecipeView(),
        MyProfileView.routeName: (_) => const MyProfileView(),
        YourProfileView.routeName: (_) => const YourProfileView(),
        EditProfileView.routeName: (_) => const EditProfileView(),
        EditRecipeView.routeName: (_) => const EditRecipeView(),
      },
      onGenerateRoute: generateRoute,
    );
  }
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    default:
      return MaterialPageRoute(
        builder: (_) => const SplashView(),
      );
  }
}
