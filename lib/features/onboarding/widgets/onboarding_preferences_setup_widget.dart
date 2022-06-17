import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../discover_recipes/widgets/allergies_widget.dart';
import '../../discover_recipes/widgets/appliances_widget.dart';
import '../../discover_recipes/widgets/cuisines_widget.dart';
import '../../discover_recipes/widgets/diets_widget.dart';

class OnboardingPreferencesSetupWidget extends HookConsumerWidget {
  const OnboardingPreferencesSetupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollBarController = useScrollController();

    return Scrollbar(
      controller: scrollBarController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollBarController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Do you have any allergies?',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'Select all that apply',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const AllergiesWidget(),
              const SizedBox(height: 24),
              Text(
                'Any dietary preferences?',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'Deselect those you avoid',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const DietsWidget(),
              const SizedBox(height: 24),
              Text(
                'Any cuisine preferences?',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'Deselect those you dislike',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const CuisinesWidget(),
              const SizedBox(height: 24),
              Text(
                'Missing any appliances?',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'Deselect those you don\'t have',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const AppliancesWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
