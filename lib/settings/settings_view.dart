import 'package:bindl/signin/sign_in_view.dart';
import 'package:flutter/material.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController _settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
        padding: const EdgeInsets.all(16),
        child: DropdownButton<ThemeMode>(
          value: _settingsController.themeMode,
          onChanged: _settingsController.updateThemeMode,
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
    );
  }
}
