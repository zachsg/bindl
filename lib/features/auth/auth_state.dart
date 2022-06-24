import 'package:bodai/extensions.dart';
import 'package:bodai/features/auth/auth_view.dart';
import 'package:bodai/features/bottom_nav_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      context.goNamed(AuthView.routeName);
    }
  }

  @override
  void onAuthenticated(Session session) {
    if (mounted) {
      context.goNamed(BottomNavView.routeName);
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}
