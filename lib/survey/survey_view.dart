import 'package:bindl/shared/providers.dart';
import 'package:bindl/survey/survey_form.dart';
import 'package:flutter/material.dart';
import 'package:bindl/survey/survey_stack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({Key? key}) : super(key: key);

  static const routeName = '/survey';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final surveyNotifier = ref.watch(surveyProvider);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: surveyNotifier.mealsEmpty()
                  ? const SurveyForm()
                  : const SurveyStack(),
            );
          },
        ),
      ),
    );
  }
}
