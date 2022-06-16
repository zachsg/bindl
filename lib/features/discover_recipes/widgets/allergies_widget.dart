import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/allergy.dart';
import 'allergy_chip_widget.dart';

class AllergiesWidget extends ConsumerWidget {
  const AllergiesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16,
      children: const [
        AllergyChipWidget(allergy: Allergy.wheat),
        AllergyChipWidget(allergy: Allergy.soy),
        AllergyChipWidget(allergy: Allergy.sesame),
        AllergyChipWidget(allergy: Allergy.dairy),
        AllergyChipWidget(allergy: Allergy.eggs),
        AllergyChipWidget(allergy: Allergy.peanuts),
        AllergyChipWidget(allergy: Allergy.treeNuts),
        AllergyChipWidget(allergy: Allergy.shellfish),
      ],
    );
  }
}
