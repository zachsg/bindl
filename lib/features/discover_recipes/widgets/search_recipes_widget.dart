import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../discover_recipes_controller.dart';

class SearchRecipesWidget extends HookConsumerWidget {
  const SearchRecipesWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useTextEditingController(text: ref.read(searchedTextProvider));

    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        isDense: true,
        // isCollapsed: trsue,
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
        label: Text('Looking for Something?'),
      ),
      onChanged: (text) {
        ref.read(searchedTextProvider.notifier).state = text;
      },
    );
  }
}
