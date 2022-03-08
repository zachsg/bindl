import 'package:bodai/features/auth/sign_in/sign_in_view.dart';
import 'package:bodai/features/bottom_nav_view.dart';
import 'package:bodai/features/discover_recipes/discover_recipes_view.dart';
import 'package:bodai/features/feed/create_post_view.dart';
import 'package:bodai/features/feed/feed_view.dart';
import 'package:bodai/features/profile/edit_profile_view.dart';
import 'package:bodai/features/profile/edit_recipe_view.dart';
import 'package:bodai/features/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/auth/auth_controller.dart';
import 'features/auth/sign_up/sign_up_view.dart';

class BodaiApp extends HookConsumerWidget {
  const BodaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      restorationScopeId: 'app',
      title: 'Bodai',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
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
              case FeedView.routeName:
                return const FeedView();
              case CreatePostView.routeName:
                return const CreatePostView();
              case DiscoverRecipesView.routeName:
                return const DiscoverRecipesView();
              case ProfileView.routeName:
                return const ProfileView();
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
