import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../discover_recipes/widgets/allergies_widget.dart';
import '../../discover_recipes/widgets/appliances_widget.dart';
import '../../discover_recipes/widgets/cuisines_widget.dart';
import '../../discover_recipes/widgets/diets_widget.dart';

class OnboardingPreferencesSetupWidget extends HookConsumerWidget {
  const OnboardingPreferencesSetupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scrollBarController = useScrollController();

    return Scrollbar(
      controller: _scrollBarController,
      isAlwaysShown: true,
      child: SingleChildScrollView(
        controller: _scrollBarController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Do you have any allergies?',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Text(
                'Select all that apply',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const AllergiesWidget(),
              const SizedBox(height: 24),
              Text(
                'Do you follow any diets?',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Text(
                'Select all that apply',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const DietsWidget(),
              const SizedBox(height: 24),
              Text(
                'What cuisines do you like?',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Text(
                'Select all that apply',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const CuisinesWidget(),
              const SizedBox(height: 24),
              Text(
                'Which appliances do you have?',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Text(
                'Select all that apply',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const AppliancesWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
