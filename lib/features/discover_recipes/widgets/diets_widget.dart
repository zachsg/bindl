import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/diet.dart';
import 'diet_chip_widget.dart';

class DietsWidget extends ConsumerWidget {
  const DietsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16,
      children: const [
        DietChipWidget(diet: Diet.omnivore),
        DietChipWidget(diet: Diet.keto),
        DietChipWidget(diet: Diet.paleo),
        DietChipWidget(diet: Diet.vegetarian),
        DietChipWidget(diet: Diet.vegan),
      ],
    );
  }
}
