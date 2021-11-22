import 'package:bindl/meal_plan/meal_plan_view.dart';
import 'package:bindl/signin/sign_in_controller.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  static const routeName = '/sign_in';

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
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
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });

                          _signInController.signUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: const Text('Sign Up'),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          final success = await _signInController.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          print('view: $success');

                          if (success) {
                            Navigator.restorablePushNamed(
                                context, MealPlanView.routeName);
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
