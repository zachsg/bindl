import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreferenceCardWidget extends ConsumerWidget {
  const PreferenceCardWidget({
    Key? key,
    required this.title,
    required this.widget,
  }) : super(key: key);

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      // title: Text(
      //   title,
      //   style: const TextStyle(fontSize: 24),
      // ),
      subtitle: widget,
    );
  }
}
