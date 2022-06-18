import 'package:bodai/features/auth/auth_state.dart';
import 'package:bodai/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_controller.dart';

final emailAuthProvider = StateProvider<String>((ref) => '');
final requestedMagicLinkProvider = StateProvider<bool>((ref) => false);

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  static const routeName = '/authenticate';

  @override
  AuthViewState createState() => AuthViewState();
}

class AuthViewState extends AuthState<AuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/images/bodai_expanded_logo_white.png'
                  : 'assets/images/bodai_expanded_logo.png',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          Consumer(
            builder: (context, ref, child) =>
                ref.watch(requestedMagicLinkProvider)
                    ? const SizedBox()
                    : const EmailTextFieldWidget(),
          ),
          Consumer(
            builder: (context, ref, child) =>
                ref.watch(requestedMagicLinkProvider)
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Check your email (${ref.watch(emailAuthProvider)}) for a link to sign into Bodai!',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ref.watch(loadingProvider)
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              ref.read(loadingProvider.notifier).state = true;

                              final email = ref.read(emailAuthProvider);
                              await AuthController.signIn(email, kIsWeb);
                              ref
                                  .read(requestedMagicLinkProvider.notifier)
                                  .state = true;

                              ref.read(loadingProvider.notifier).state = false;
                            },
                            child: const Text('Get Magic Sign-In Link'),
                          ),
          ),
        ],
      ),
    );
  }
}

class EmailTextFieldWidget extends HookConsumerWidget {
  const EmailTextFieldWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        onChanged: (text) => ref.read(emailAuthProvider.notifier).state = text,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
