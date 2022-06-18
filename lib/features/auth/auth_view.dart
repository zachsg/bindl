import 'package:bodai/features/auth/auth_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_controller.dart';
import 'widgets/email_text_field_widget.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  static const routeName = '/authenticate';

  @override
  AuthViewState createState() => AuthViewState();
}

class AuthViewState extends AuthState<AuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/images/bodai_expanded_logo_white.png'
                  : 'assets/images/bodai_expanded_logo.png',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          const EmailTextFieldWidget(),
          Consumer(
            builder: (context, ref, child) => ElevatedButton(
              onPressed: () async {
                final email = ref.read(emailAuthProvider);
                await AuthController.signIn(email, kIsWeb);
              },
              child: const Text('Get Magic Sign-In Link'),
            ),
          ),
        ],
      ),
    );
  }
}
