import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/user_controller.dart';
import 'widgets/onboarding_card_widget.dart';
import 'widgets/onboarding_preferences_setup_widget.dart';
import 'widgets/onboarding_profile_setup_widget.dart';
import 'widgets/onboarding_summary_widget.dart';

final onboardingPageNumberProvider = StateProvider<int>((ref) => 0);

class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  static const routeName = '/onboarding';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = PageController(viewportFraction: 1 / 1.2);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Welcome to Bodai!',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                onPageChanged: (index) {
                  ref.read(onboardingPageNumberProvider.notifier).state = index;

                  if (index == 1) {
                    ref.read(userProvider.notifier).save();
                  }
                },
                controller: controller,
                children: const [
                  OnboardingCardWidget(
                    child: OnboardingProfileSetupWidget(),
                  ),
                  OnboardingCardWidget(
                    child: OnboardingPreferencesSetupWidget(),
                  ),
                  OnboardingCardWidget(
                    child: OnboardingSummaryWidget(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Step ${ref.watch(onboardingPageNumberProvider) + 1} of 3',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16, color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
