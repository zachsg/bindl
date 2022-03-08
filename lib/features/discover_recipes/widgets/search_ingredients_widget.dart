import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchIngredientsWidget extends HookConsumerWidget {
  const SearchIngredientsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        // onChanged: (text) => ref.read(emailAuthProvider.notifier).state = text,
        decoration: const InputDecoration(
          labelText: 'Enter ingredient',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
