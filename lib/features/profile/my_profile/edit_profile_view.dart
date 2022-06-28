import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../constants.dart';
import '../../../providers/user_controller.dart';
import '../../auth/auth_controller.dart';
import '../../auth/auth_view.dart';
import 'widgets/avatar_picker_widget.dart';
import 'widgets/bio_text_field_widget.dart';
import 'widgets/experience_dropdown_widget.dart';
import 'widgets/handle_text_field_widget.dart';
import 'widgets/name_text_field_widget.dart';
import 'widgets/theme_dropdown_button_widget.dart';

final systemInfoFutureProvider = FutureProvider.autoDispose<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

class EditProfileView extends ConsumerWidget {
  const EditProfileView({super.key});

  static const routeName = 'edit_profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureSystemInfo = ref.watch(systemInfoFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          MaterialButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              var success = await ref.read(userProvider.notifier).save();

              final message = success
                  ? 'Profile updated!'
                  : 'Failed to save changes: That handle isn\'t available!';
              final snackBar = SnackBar(content: Text(message));
              scaffoldMessenger.removeCurrentSnackBar();
              scaffoldMessenger.showSnackBar(snackBar);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final goRouter = GoRouter.of(context);

                        await AuthController.signOut();

                        goRouter.goNamed(AuthView.routeName);
                      },
                      child: const Text('Sign out'),
                    ),
                    TextButton(
                      onPressed: () => _showMyDialog(
                          context,
                          'Request Account Deletion',
                          const Text(
                              'Click \'Delete Me\' to confirm that you would like Bodai to remove your account. We\'ll email you a confirmation when it\'s done.'),
                          ref),
                      child: const Text('Delete account'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, String title, Widget widget, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: widget),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete Me'),
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                if (supabase.auth.currentUser != null) {
                  final Email email = Email(
                    body:
                        'Please delete my Bodai account associated with ${supabase.auth.currentUser?.email}',
                    subject: 'Account Deletion Request',
                    recipients: ['team@bodai.co'],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(email);

                  const snackBar = SnackBar(
                      content: Text(
                          'We\'ve received your request, will be in touch shortly to confirm account deletion.'));
                  scaffoldMessenger.removeCurrentSnackBar();
                  scaffoldMessenger.showSnackBar(snackBar);
                }

                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
