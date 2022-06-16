import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreferenceCardWidget extends ConsumerWidget {
  const PreferenceCardWidget({
    super.key,
    required this.title,
    required this.widget,
  });

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(subtitle: widget);
  }
}
