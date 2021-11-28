import 'package:bindl/meal_plan/meal_plan_view.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/sign_in/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  static const routeName = '/sign_in';

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  late final AuthController _signInController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _signInController = AuthController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                      ),
                      ref.watch(userProvider).hasAccount()
                          ? TextButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                final success = await _signInController.signIn(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                if (success) {
                                  Navigator.restorablePushNamed(
                                      context, MealPlanView.routeName);
                                }

                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              child: const Text('Sign In'),
                            )
                          : TextButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                bool success = await _signInController.signUp(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                if (success) {
                                  // TODO: Save userProvider data to DB
                                  var uc = ref.read(userProvider);
                                  await uc.saveUserData();

                                  // TODO: Clear navigation stack after logging in so user doesn't go backwards accidentally
                                  Navigator.restorablePushNamed(
                                      context, MealPlanView.routeName);
                                }

                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              child: const Text('Sign Up'),
                            ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
