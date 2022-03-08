import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth_controller.dart';

class PasswordConfirmTextFieldWidget extends HookConsumerWidget {
  const PasswordConfirmTextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        onChanged: (text) =>
            ref.read(passwordConfirmAuthProvider.notifier).state = text,
        decoration: const InputDecoration(
          labelText: 'Confirm password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
