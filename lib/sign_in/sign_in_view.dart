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
  late final SignInController _signInController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _signInController = SignInController();
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
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ref.watch(userProvider).hasAccount()
                          ? ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                final success = await _signInController.signIn(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                setState(() {
                                  _isLoading = false;
                                });

                                if (success) {
                                  Navigator.restorablePushNamed(
                                      context, MealPlanView.routeName);
                                } else {
                                  const snackBar = SnackBar(
                                    content:
                                        Text('Incorrect username/password'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Container(
                                width: 200,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('SIGN IN'),
                                  ],
                                ),
                              ),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                bool success = await _signInController.signUp(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                if (success) {
                                  var uc = ref.read(userProvider);

                                  await uc.saveUserData();
                                  uc.setHasAccount(true);

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  Navigator.pushNamedAndRemoveUntil(context,
                                      MealPlanView.routeName, (r) => false);
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  const snackBar = SnackBar(
                                    content: Text('Failed to create account'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Container(
                                width: 200,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('SIGN UP'),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
