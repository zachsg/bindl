import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bindl_app.dart';
import 'settings/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jtsktndbkvgansrlzkia.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNzUxNjYzOSwiZXhwIjoxOTUzMDkyNjM5fQ.K4Kg0WY0f4mmzU__7PQI4u-6CX1Q_KjFGn17XKURmUA',
  );

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController();

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(
    BindlApp(settingsController: settingsController),
  );
}
