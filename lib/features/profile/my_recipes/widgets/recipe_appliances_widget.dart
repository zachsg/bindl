import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/xmodels.dart';
import 'recipe_appliance_chip_widget.dart';

class RecipeAppliancesWidget extends ConsumerWidget {
  const RecipeAppliancesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Recipe appliances',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'select all that apply',
            style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontStyle: FontStyle.italic),
          ),
          Wrap(
            spacing: 16,
            children: const [
              RecipeApplianceChipWidget(appliance: Appliance.oven),
              RecipeApplianceChipWidget(appliance: Appliance.stovetop),
              RecipeApplianceChipWidget(appliance: Appliance.airFryer),
              RecipeApplianceChipWidget(appliance: Appliance.instantPot),
              RecipeApplianceChipWidget(appliance: Appliance.blender),
            ],
          ),
        ],
      ),
    );
  }
}
