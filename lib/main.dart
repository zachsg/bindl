import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bodai_app.dart';

const supabaseURL = 'https://qcryzjgjqhavbupdnpdl.supabase.co';
const supabasePublicKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjcnl6amdqcWhhdmJ1cGRucGRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDYwNzc0OTAsImV4cCI6MTk2MTY1MzQ5MH0.iYzLruqaN-IIN0tsB19orz4M6iHn86pCU7baWszzAEs';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseURL,
    anonKey: supabasePublicKey,
  );

  runApp(
    const ProviderScope(
      child: BodaiApp(),
    ),
  );
}
