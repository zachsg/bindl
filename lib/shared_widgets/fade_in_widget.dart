import 'package:bodai/controllers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FadeInWidget extends ConsumerWidget {
  const FadeInWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      opacity: ref.watch(opacityProvider),
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
