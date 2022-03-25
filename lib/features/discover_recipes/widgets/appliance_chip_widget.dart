import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../../providers/user_controller.dart';

class ApplianceChipWidget extends ConsumerWidget {
  const ApplianceChipWidget({Key? key, required this.appliance})
      : super(key: key);

  final Appliance appliance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var applianceName = appliance.name;
    if (appliance == Appliance.airFryer) {
      applianceName = 'air fryer';
    } else if (appliance == Appliance.instantPot) {
      applianceName = 'instant pot';
    }

    return FilterChip(
      label: Text(applianceName),
      selected: ref.watch(userProvider).appliances.contains(appliance),
      onSelected: (selected) {
        ref.read(userProvider.notifier).setAppliance(appliance, selected);
      },
    );
  }
}
