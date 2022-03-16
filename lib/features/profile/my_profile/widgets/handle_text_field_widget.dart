import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/user_controller.dart';

class HandleTextFieldWidget extends HookConsumerWidget {
  const HandleTextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useTextEditingController(text: ref.watch(userProvider).handle);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        onChanged: (text) => ref.read(userProvider.notifier).setHandle(text),
        decoration: const InputDecoration(
          labelText: 'Handle',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
