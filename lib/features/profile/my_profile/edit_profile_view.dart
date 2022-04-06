import 'package:bodai/features/profile/my_profile/widgets/avatar_picker_widget.dart';
import 'package:bodai/features/profile/my_profile/widgets/bio_text_field_widget.dart';
import 'package:bodai/features/profile/my_profile/widgets/experience_dropdown_widget.dart';
import 'package:bodai/features/profile/my_profile/widgets/handle_text_field_widget.dart';
import 'package:bodai/features/profile/my_profile/widgets/name_text_field_widget.dart';
import 'package:bodai/providers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../auth/auth_controller.dart';
import '../../auth/sign_in/sign_in_view.dart';

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
          TextButton(
            onPressed: () async {
              var success = await ref.read(userProvider.notifier).save();

              final message =
                  success ? 'Profile updated!' : 'Failed to save changes';
              final snackBar = SnackBar(content: Text(message));
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
                TextButton(
                  onPressed: () async {
                    await AuthController.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, SignInView.routeName, (route) => false);
                  },
                  child: const Text('Sign out'),
                ),
                const SizedBox(height: 16),
                futureSystemInfo.when(
                  data: (packageInfo) => Text(
                    '${packageInfo.version} (${packageInfo.buildNumber})',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  error: (e, st) => const Center(child: Text('')),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
