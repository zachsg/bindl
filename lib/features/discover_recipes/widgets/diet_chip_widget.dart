import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/diet.dart';
import '../../../providers/user_controller.dart';

class DietChipWidget extends ConsumerWidget {
  const DietChipWidget({super.key, required this.diet});

  final Diet diet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilterChip(
      label: Text(diet.name),
      selected: ref.watch(userProvider).diets.contains(diet),
      onSelected: (selected) {
        ref.read(userProvider.notifier).setDiet(diet, selected);
      },
    );
  }
}
