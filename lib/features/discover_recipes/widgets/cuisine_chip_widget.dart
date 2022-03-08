import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/user_controller.dart';
import '../../../models/cuisine.dart';

class CuisineChipWidget extends ConsumerWidget {
  const CuisineChipWidget({Key? key, required this.cuisine}) : super(key: key);

  final Cuisine cuisine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilterChip(
      label: Text(cuisine.name),
      selected: ref.watch(userProvider).cuisines.contains(cuisine),
      onSelected: (selected) {
        ref.read(userProvider.notifier).setCuisine(cuisine, selected);
      },
    );
  }
}
