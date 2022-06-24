import 'package:bodai/features/auth/auth_view.dart';
import 'package:bodai/features/bottom_nav_view.dart';
import 'package:bodai/features/discover_recipes/discover_recipes_view.dart';
import 'package:bodai/features/discover_recipes/recipe_view.dart';
import 'package:bodai/features/onboarding/onboarding_view.dart';
import 'package:bodai/features/pantry/pantry_view.dart';
import 'package:bodai/features/profile/my_recipes/edit_recipe_view.dart';
import 'package:bodai/features/splash/splash_view.dart';
import 'package:bodai/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
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
    );
  }

  final router = GoRouter(
    initialLocation: SplashView.routeName,
    routes: [
      GoRoute(
        name: SplashView.routeName,
        path: SplashView.routeName,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        name: AuthView.routeName,
        path: AuthView.routeName,
        builder: (context, state) => const AuthView(),
      ),
      GoRoute(
        name: BottomNavView.routeName,
        path: BottomNavView.routeName,
        builder: (context, state) => const BottomNavView(),
        routes: [],
      ),
      GoRoute(
        name: OnboardingView.routeName,
        path: OnboardingView.routeName,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        name: PantryView.routeName,
        path: PantryView.routeName,
        builder: (context, state) => const PantryView(),
      ),
      GoRoute(
        name: DiscoverRecipesView.routeName,
        path: DiscoverRecipesView.routeName,
        builder: (context, state) => const DiscoverRecipesView(),
        routes: [
          GoRoute(
            name: RecipeView.routeName,
            path: '${RecipeView.routeName}/:id',
            builder: (context, state) =>
                RecipeView(recipe: state.extra as Recipe),
          ),
        ],
      ),
      GoRoute(
        name: MyProfileView.routeName,
        path: MyProfileView.routeName,
        builder: (context, state) => const MyProfileView(),
        routes: [
          GoRoute(
            name: EditProfileView.routeName,
            path: EditProfileView.routeName,
            builder: (context, state) => const EditProfileView(),
          ),
          GoRoute(
            name: EditRecipeView.routeName,
            path: EditRecipeView.routeName,
            builder: (context, state) => const EditRecipeView(),
          ),
        ],
      ),
      GoRoute(
        name: YourProfileView.routeName,
        path: YourProfileView.routeName,
        builder: (context, state) => const YourProfileView(),
        routes: [
          GoRoute(
            name: '${RecipeView.routeName}yours',
            path: '${RecipeView.routeName}/:id',
            builder: (context, state) =>
                RecipeView(recipe: state.extra as Recipe),
          ),
        ],
      ),
    ],
  );
}
