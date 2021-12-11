import 'package:bindl/shared/providers.dart';
import 'package:bindl/shared/widgets.dart';
import 'package:bindl/sign_in/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyForm extends ConsumerStatefulWidget {
  const SurveyForm({Key? key}) : super(key: key);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends ConsumerState<SurveyForm> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  AllergyCard(),
                  SizedBox(height: 20),
                  AdoreIngredientsCard(),
                  SizedBox(height: 20),
                  AbhorIngredientsCard(),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    ref.watch(settingsProvider).surveyIsDone
                        ? _save()
                        : Navigator.restorablePushNamed(
                            context, SignInView.routeName);
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                ref.watch(settingsProvider).surveyIsDone
                                    ? 'SAVE'
                                    : 'LET\'S GO',
                              ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() {
      _isLoading = true;
    });

    var saved = await ref.read(userProvider).saveUserData();

    if (saved) {
      // const snackBar = SnackBar(content: Text('Updated!'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      await ref.read(userProvider).computeMealPlan();
      await ref
          .read(mealPlanProvider)
          .loadMealsForIDs(ref.read(userProvider).recipes());

      ref.read(userProvider).setUpdatesPending(true);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
