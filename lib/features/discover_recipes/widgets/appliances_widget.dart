import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import 'appliance_chip_widget.dart';

class AppliancesWidget extends ConsumerWidget {
  const AppliancesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16,
      children: const [
        ApplianceChipWidget(appliance: Appliance.oven),
        ApplianceChipWidget(appliance: Appliance.stovetop),
        ApplianceChipWidget(appliance: Appliance.airFryer),
        ApplianceChipWidget(appliance: Appliance.instantPot),
        ApplianceChipWidget(appliance: Appliance.blender),
      ],
    );
  }
}
