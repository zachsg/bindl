import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/user_controller.dart';
import '../../../models/allergy.dart';

class AllergyChipWidget extends ConsumerWidget {
  const AllergyChipWidget({super.key, required this.allergy});

  final Allergy allergy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilterChip(
      label: Text(
          allergy.name == Allergy.treeNuts.name ? 'tree nuts' : allergy.name),
      selected: ref.watch(userProvider).allergies.contains(allergy),
      onSelected: (selected) {
        ref.read(userProvider.notifier).setAllergy(allergy, selected);
      },
    );
  }
}
