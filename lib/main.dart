import 'package:bindl/shared/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bindl_app.dart';
import 'settings/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseURL,
    anonKey: supabasePublicKey,
  );

  final settingsController = SettingsController();
  await settingsController.loadSettings();

  runApp(
    const ProviderScope(
      child: BindlApp(),
    ),
  );
}
