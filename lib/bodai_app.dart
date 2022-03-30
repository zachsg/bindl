import 'package:bodai/features/auth/sign_in/sign_in_view.dart';
import 'package:bodai/features/bottom_nav_view.dart';
import 'package:bodai/features/discover_recipes/discover_recipes_view.dart';
import 'package:bodai/features/discover_recipes/recipe_view.dart';
import 'package:bodai/features/onboarding/onboarding_view.dart';
import 'package:bodai/features/pantry/pantry_view.dart';
import 'package:bodai/features/profile/my_recipes/edit_recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/auth/auth_controller.dart';
import 'features/auth/sign_up/sign_up_view.dart';
import 'features/profile/my_profile/edit_profile_view.dart';
import 'features/profile/my_profile/my_profile_view.dart';
import 'features/profile/your_profile/your_profile_view.dart';

class BodaiApp extends HookConsumerWidget {
  const BodaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      restorationScopeId: 'app',
      title: 'Bodai',
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.red,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case SignUpView.routeName:
                return const SignUpView();
              case SignInView.routeName:
                return const SignInView();
              case BottomNavView.routeName:
                return const BottomNavView();
              case OnboardingView.routeName:
                return const OnboardingView();
              // case FeedView.routeName:
              //   return const FeedView();
              // case CreatePostView.routeName:
              //   return const CreatePostView();
              case PantryView.routeName:
                return const PantryView();
              case DiscoverRecipesView.routeName:
                return const DiscoverRecipesView();
              case RecipeView.routeName:
                return RecipeView();
              case MyProfileView.routeName:
                return const MyProfileView();
              case YourProfileView.routeName:
                return const YourProfileView();
              case EditProfileView.routeName:
                return const EditProfileView();
              case EditRecipeView.routeName:
                return const EditRecipeView();
              default:
                return AuthController.isLoggedIn
                    ? const BottomNavView()
                    : const SignUpView();
            }
          },
        );
      },
    );
  }
}
