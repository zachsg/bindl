import 'package:bindl/meal_plan/meal_plan_view.dart';
import 'package:bindl/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  static const routeName = '/sign_in';

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    loadSettings();
  }

  Future<void> loadSettings() async {
    await ref.read(settingsProvider).loadSettings();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                      Text(
                        'Bindl',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(height: 24),
                      emailTextField(),
                      const SizedBox(height: 24),
                      passwordTextField(),
                      const SizedBox(height: 24),
                      ref.read(userProvider).hasAccount() ||
                              ref.read(settingsProvider).surveyIsDone
                          ? signInButton()
                          : signUpButton()
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      controller: _passwordController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });

        bool success = await ref.read(signInProvider).signUp(
              email: _emailController.text,
              password: _passwordController.text,
            );

        if (success) {
          var uc = ref.read(userProvider);

          var wasSaved = await uc.saveUserData();
          if (wasSaved) {
            uc.setHasAccount(true);

            ref.read(settingsProvider).completeSurvey(true);

            setState(() {
              _isLoading = false;
            });

            Navigator.pushNamedAndRemoveUntil(
                context, MealPlanView.routeName, (r) => false);
          } else {
            _isLoading = false;

            const snackBar = SnackBar(
              content: Text('Failed to save info'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          setState(() {
            _isLoading = false;
          });

          const snackBar = SnackBar(
            content: Text('Failed to create account'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('SIGN UP'),
          ],
        ),
      ),
    );
  }

  Widget signInButton() {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });

        final success = await ref.read(signInProvider).signIn(
              email: _emailController.text,
              password: _passwordController.text,
            );

        setState(() {
          _isLoading = false;
        });

        if (success) {
          Navigator.pushNamedAndRemoveUntil(
              context, MealPlanView.routeName, (r) => false);
        } else {
          const snackBar = SnackBar(
            content: Text('Incorrect username/password'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('SIGN IN'),
          ],
        ),
      ),
    );
  }
}
