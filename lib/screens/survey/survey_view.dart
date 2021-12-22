import 'package:bindl/controllers/xcontrollers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'survey_form.dart';
import 'survey_stack.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({Key? key}) : super(key: key);

  static const routeName = '/survey';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ref.watch(surveyProvider).mealsEmpty()
                  ? const SurveyForm()
                  : const SurveyStack(),
            );
          },
        ),
      ),
    );
  }
}
