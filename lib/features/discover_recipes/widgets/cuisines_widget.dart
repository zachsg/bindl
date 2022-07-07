import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/cuisine.dart';
import 'cuisine_chip_widget.dart';

class CuisinesWidget extends ConsumerWidget {
  const CuisinesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16,
      children: const [
        CuisineChipWidget(cuisine: Cuisine.american),
        CuisineChipWidget(cuisine: Cuisine.mexican),
        CuisineChipWidget(cuisine: Cuisine.spanish),
        CuisineChipWidget(cuisine: Cuisine.french),
        CuisineChipWidget(cuisine: Cuisine.german),
        CuisineChipWidget(cuisine: Cuisine.italian),
        CuisineChipWidget(cuisine: Cuisine.mediterranean),
        CuisineChipWidget(cuisine: Cuisine.caribbean),
        CuisineChipWidget(cuisine: Cuisine.turkish),
        CuisineChipWidget(cuisine: Cuisine.indian),
        CuisineChipWidget(cuisine: Cuisine.chinese),
        CuisineChipWidget(cuisine: Cuisine.thai),
        CuisineChipWidget(cuisine: Cuisine.japanese),
        CuisineChipWidget(cuisine: Cuisine.korean),
      ],
    );
  }
}
