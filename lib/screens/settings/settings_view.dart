import 'package:bodai/controllers/xcontrollers.dart';
import 'package:bodai/screens/sign_in/sign_in_view.dart';
import 'package:bodai/widgets/xwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sp = ref.watch(settingsProvider);
    var up = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       final success = await ref.read(settingsProvider).signOut();

        //       if (success) {
        //         Navigator.restorablePushNamed(context, SignInView.routeName);
        //       }
        //     },
        //     icon: const Icon(Icons.logout),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButton<ThemeMode>(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(10),
                    icon: Icon(
                      Icons.color_lens_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    underline: const SizedBox(),
                    value: ref.watch(settingsProvider).themeMode,
                    onChanged:
                        ref.watch(settingsProvider.notifier).updateThemeMode,
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(
                          'System Theme ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600),
                        ),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text(
                          'Light Theme',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text(
                          'Dark Theme',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Version: ${ref.watch(settingsProvider.notifier).appVersion}'
                    ' (${ref.watch(settingsProvider.notifier).appBuildNumber})',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'I\'m cooking for',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    DropdownButton(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10),
                      value: up.servings - 1,
                      icon: const SizedBox(),
                      underline: const SizedBox(),
                      items: _getServingsOptions(context),
                      onChanged: (value) async {
                        var servings = (value as int) + 1;

                        await ref.read(userProvider).setServings(servings);
                      },
                    ),
                    Text(
                      up.servings == 1 ? 'person.' : 'people.',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const AllergyCard(shouldPersist: true),
            const SizedBox(height: 16),
            const AdoreIngredientsCard(shouldPersist: true),
            const SizedBox(height: 16),
            const AbhorIngredientsCard(shouldPersist: true),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> _getServingsOptions(BuildContext context) {
    List<DropdownMenuItem<int>> items = [];

    for (var i = 0; i < 6; i++) {
      var item = DropdownMenuItem(
        value: i,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${i + 1}',
            style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      );

      items.add(item);
    }

    return items;
  }
}
