import 'package:bodai/features/auth/auth_controller.dart';
import 'package:bodai/features/auth/sign_in/sign_in_view.dart';
import 'package:bodai/features/auth/widgets/email_text_field_widget.dart';
import 'package:bodai/features/auth/widgets/password_text_field_widget.dart';
import 'package:bodai/features/bottom_nav_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'password_confirm_text_field_widget.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({Key? key}) : super(key: key);

  static const routeName = '/sign_up';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Image.asset(
              'assets/images/bodai_expanded_logo.png',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          const EmailTextFieldWidget(),
          const PasswordTextFieldWidget(),
          const PasswordConfirmTextFieldWidget(),
          ElevatedButton(
            onPressed: () async {
              // Sign user up
              var email = ref.read(emailAuthProvider);
              var password = ref.read(passwordAuthProvider);
              var passwordConfirm = ref.read(passwordConfirmAuthProvider);

              if (!AuthController.passwordsDoMatch(password, passwordConfirm)) {
                const snackBar =
                    SnackBar(content: Text('Passwords do not match.'));
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }

              final success = await AuthController.signUpWithEmailAndPassword(
                  email, password);
              if (!success) {
                const snackBar =
                    SnackBar(content: Text('Failed to create account.'));
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }

              Navigator.pushNamedAndRemoveUntil(
                  context, BottomNavView.routeName, (route) => false);
            },
            child: const Text('Sign Up'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, SignInView.routeName, (route) => false);
            },
            child: const Text('I have an account'),
          ),
        ],
      ),
    );
  }
}
