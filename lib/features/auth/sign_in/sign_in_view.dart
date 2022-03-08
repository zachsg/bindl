import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../bottom_nav_view.dart';
import '../auth_controller.dart';
import '../sign_up/sign_up_view.dart';
import '../widgets/email_text_field_widget.dart';
import '../widgets/password_text_field_widget.dart';

class SignInView extends ConsumerWidget {
  const SignInView({Key? key}) : super(key: key);

  static const routeName = '/sign_in';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sign In'),
          const EmailTextFieldWidget(),
          const PasswordTextFieldWidget(),
          ElevatedButton(
            onPressed: () async {
              // Sign user up
              var email = ref.read(emailAuthProvider);
              var password = ref.read(passwordAuthProvider);

              final success = await AuthController.signInWithEmailAndPassword(
                  email, password);
              if (!success) {
                const snackBar = SnackBar(content: Text('Failed to sign in.'));
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }

              Navigator.pushNamedAndRemoveUntil(
                  context, BottomNavView.routeName, (route) => false);
            },
            child: const Text('Sign In'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, SignUpView.routeName, (route) => false);
            },
            child: const Text('Register new account'),
          ),
          // TextButton(
          //   onPressed: () async {
          //     await AuthController.signInWithGoogle();
          //   },
          //   child: const Text('Sign in with Google'),
          // ),
        ],
      ),
    );
  }
}
