import 'package:bodai/controllers/providers.dart';
import 'package:bodai/screens/bottom_nav_view.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  static const routeName = '/sign_up';

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Image.asset(
                          assetBodaiLogoLabel,
                          width: 200,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _emailTextField(),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _passwordTextField(),
                          const SizedBox(height: 12),
                          _passwordConfirmTextField(),
                          const SizedBox(height: 24),
                          _signUpButton(),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelText: emailLabel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      controller: _passwordController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelText: passwordLabel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _passwordConfirmTextField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      controller: _passwordConfirmController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelText: 'Confirm $passwordLabel',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
      onPressed: () async {
        if (_emailController.text.isEmpty) {
          const snackBar = SnackBar(
            content: Text('Email cannot be blank'),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          return;
        }

        if (_passwordController.text.isEmpty) {
          const snackBar = SnackBar(
            content: Text('Password cannot be blank'),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          return;
        }

        if (_passwordController.text != _passwordConfirmController.text) {
          const snackBar = SnackBar(
            content: Text('Passwords don\'t match'),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          return;
        }

        setState(() {
          _isLoading = true;
        });

        var response = await ref.read(signInProvider).signUp(
              email: _emailController.text,
              password: _passwordController.text,
            );

        if (response == successLabel) {
          var saved = await ref.read(userProvider).save();

          if (saved) {
            await ref.read(userProvider).setHasAccount(true);

            await ref.read(settingsProvider.notifier).completeSurvey(true);

            await ref.read(mealsProvider.notifier).load();

            setState(() {
              _isLoading = false;
            });

            Navigator.pushNamedAndRemoveUntil(
                context, BottomNavView.routeName, (r) => false);
          } else {
            setState(() {
              _isLoading = false;
            });

            const snackBar = SnackBar(
              content: Text(failedToSaveInfoLabel),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          setState(() {
            _isLoading = false;
          });

          final snackBar = SnackBar(
            content: Text(response),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 64.0,
          vertical: 16.0,
        ),
        child: Text(signUpLabel),
      ),
    );
  }
}
