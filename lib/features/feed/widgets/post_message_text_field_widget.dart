import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../new_post_controller.dart';

class PostMessageTextFieldWidget extends HookConsumerWidget {
  const PostMessageTextFieldWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: (text) =>
            ref.read(newPostProvider.notifier).setMessage(text),
        minLines: 1,
        maxLines: 5,
        maxLength: 200,
        decoration: const InputDecoration(
          labelText: 'Message',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
