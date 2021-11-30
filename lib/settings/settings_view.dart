import 'package:bindl/shared/providers.dart';
import 'package:bindl/sign_in/sign_in_view.dart';
import 'package:bindl/survey/survey_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_controller.dart';

class SettingsView extends ConsumerWidget {
  SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController _settingsController = SettingsController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        actions: [
          IconButton(
            onPressed: () async {
              final success = await _settingsController.signOut();

              if (success) {
                Navigator.restorablePushNamed(context, SignInView.routeName);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButton<ThemeMode>(
                value: ref.watch(settingsProvider).themeMode,
                onChanged: ref.watch(settingsProvider).updateThemeMode,
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark Theme'),
                  )
                ],
              ),
            ),
            const Expanded(
              child: SurveyForm(),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
