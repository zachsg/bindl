import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../providers/providers.dart';

class OnboardingSummaryWidget extends HookConsumerWidget {
  const OnboardingSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scrollBarController = useScrollController();

    return Scrollbar(
      controller: _scrollBarController,
      isAlwaysShown: true,
      child: SingleChildScrollView(
        controller: _scrollBarController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'That\'s it! ...Now how\'s it work?',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            const Text('Bodai has 3 distinct components:'),
            Row(
              children: const [
                Text('\t1. '),
                Icon(Icons.kitchen),
                Text(' Your Pantry / Kitchen')
              ],
            ),
            Row(
              children: const [
                Text('\t2. '),
                Icon(Icons.menu_book),
                Text(' Recipe Discovery')
              ],
            ),
            Row(
              children: const [
                Text('\t3. '),
                Icon(Icons.face),
                Text(' Your Profile')
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.kitchen),
                Text(
                  ' Pantry / Kitchen',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const Text(
                'Log your ingredients (what\'s in your fridge / pantry). '
                'You can include quantities and expiration dates. '
                'Log new ingredients as you shop via the Shopping List.'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.menu_book),
                Text(
                  ' Recipe Discovery',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const Text('We use the ingredients in your pantry / fridge '
                '& your dietary + appliance preferences to find the best recipes. '
                'You\'ll waste less food by using ingredients before they go bad.'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.face),
                Text(
                  ' Profile',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const Text('Edit your profile, create your own recipes, '
                'and view your followers (+ who\'s following you). '
                'You can follow Chefs & other home cooks via their recipes.'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool(onboardingKey, true);
                    ref.read(didOnboardingProvider.notifier).state = true;
                  },
                  child: const Text('Let\'s Go!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
