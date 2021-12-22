import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bindl_app.dart';
import 'models/xmodels.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseURL,
    anonKey: supabasePublicKey,
  );

  runApp(
    const ProviderScope(
      child: BindlApp(),
    ),
  );
}
