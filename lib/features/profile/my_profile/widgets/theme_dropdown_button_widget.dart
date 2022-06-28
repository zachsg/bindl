import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants.dart';
import '../../../../providers/providers.dart';

class ThemeDropdownButtonWidget extends ConsumerWidget {
  const ThemeDropdownButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Text('Theme:'),
        const SizedBox(width: 4),
        DropdownButton<ThemeMode>(
          value: ref.watch(themeProvider),
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          underline: Container(
            height: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          onChanged: (ThemeMode? newValue) async {
            if (newValue != null) {
              final prefs = await SharedPreferences.getInstance();

              switch (newValue) {
                case ThemeMode.system:
                  prefs.setInt(themeKey, 0);
                  ref.read(themeProvider.notifier).state = ThemeMode.system;
                  break;
                case ThemeMode.light:
                  prefs.setInt(themeKey, 1);
                  ref.read(themeProvider.notifier).state = ThemeMode.light;
                  break;
                case ThemeMode.dark:
                  prefs.setInt(themeKey, 2);
                  ref.read(themeProvider.notifier).state = ThemeMode.dark;
                  break;
                default:
                  prefs.setInt(themeKey, 0);
                  ref.read(themeProvider.notifier).state = ThemeMode.system;
              }
            }
          },
          items: <ThemeMode>[
            ThemeMode.system,
            ThemeMode.light,
            ThemeMode.dark,
          ].map<DropdownMenuItem<ThemeMode>>((ThemeMode theme) {
            return DropdownMenuItem<ThemeMode>(
              value: theme,
              child: Text(theme.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}
