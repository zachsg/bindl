import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../providers/providers.dart';
import '../../../providers/user_controller.dart';
import '../../auth/auth_controller.dart';
import '../../auth/sign_in/sign_in_view.dart';
import 'widgets/avatar_picker_widget.dart';
import 'widgets/bio_text_field_widget.dart';
import 'widgets/experience_dropdown_widget.dart';
import 'widgets/handle_text_field_widget.dart';
import 'widgets/name_text_field_widget.dart';

final systemInfoFutureProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

class EditProfileView extends ConsumerWidget {
  const EditProfileView({Key? key}) : super(key: key);

  static const routeName = '/edit_profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureSystemInfo = ref.watch(systemInfoFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          MaterialButton(
            onPressed: () async {
              var success = await ref.read(userProvider.notifier).save();

              final message = success
                  ? 'Profile updated!'
                  : 'Failed to save changes: That handle already in use!';
              final snackBar = SnackBar(content: Text(message));
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    AvatarPickerWidget(),
                    SizedBox(width: 8),
                    ExperienceDropdownWidget(),
                  ],
                ),
                const NameTextFieldWidget(),
                const HandleTextFieldWidget(),
                const BioTextFieldWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 32.0,
                  ),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const ThemeDropdownButtonWidget(),
                    futureSystemInfo.when(
                      data: (packageInfo) => Text(
                        'App: ${packageInfo.version} (${packageInfo.buildNumber})',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      error: (e, st) => Center(child: Text(e.toString())),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    await AuthController.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, SignInView.routeName, (route) => false);
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeDropdownButtonWidget extends HookConsumerWidget {
  const ThemeDropdownButtonWidget({Key? key}) : super(key: key);

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
