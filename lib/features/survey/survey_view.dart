import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'survey_controller.dart';
import 'widgets/survey_form_widget.dart';
import 'widgets/survey_stack_widget.dart';

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
              child: ref.watch(surveyProvider).all.isEmpty
                  ? const SurveyFormWidget()
                  : const SurveyStackWidget(),
            );
          },
        ),
      ),
    );
  }
}
