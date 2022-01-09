import 'package:bodai/screens/sign_in/sign_up_view.dart';
import 'package:bodai/utils/strings.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyForm extends ConsumerStatefulWidget {
  const SurveyForm({Key? key}) : super(key: key);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends ConsumerState<SurveyForm> {
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
                    Navigator.pushNamedAndRemoveUntil(
                        context, SignUpView.routeName, (r) => false);
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(letsGoLabel),
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
}
