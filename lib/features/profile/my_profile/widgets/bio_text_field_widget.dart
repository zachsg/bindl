import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/user_controller.dart';

class BioTextFieldWidget extends HookConsumerWidget {
  const BioTextFieldWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useTextEditingController(text: ref.watch(userProvider).bio);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (text) => ref.read(userProvider.notifier).setBio(text),
        minLines: 1,
        maxLines: 15,
        maxLength: 600,
        decoration: const InputDecoration(
          labelText: 'Bio',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
