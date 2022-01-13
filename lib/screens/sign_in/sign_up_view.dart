import 'package:bodai/controllers/providers.dart';
import 'package:bodai/screens/meal_plan/meal_plan_view.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
                          emailTextField(),
                          const SizedBox(height: 24),
                          passwordTextField(),
                          const SizedBox(height: 24),
                          signUpButton(),
                        ],
                      ),
                    ),
                  ],
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
        labelText: emailLabel,
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
        labelText: passwordLabel,
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

        var response = await ref.read(signInProvider).signUp(
              email: _emailController.text,
              password: _passwordController.text,
            );

        if (response == successLabel) {
          var saved = await ref.read(userProvider).save();

          if (saved) {
            ref.read(userProvider).setHasAccount(true);

            await ref.read(settingsProvider.notifier).completeSurvey(true);

            await ref.read(mealsProvider.notifier).load();

            setState(() {
              _isLoading = false;
            });

            Navigator.pushNamedAndRemoveUntil(
                context, MealPlanView.routeName, (r) => false);
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
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(signUpLabel),
          ],
        ),
      ),
    );
  }
}
