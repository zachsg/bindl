import 'package:bindl/screens/my_content/recipe_ingredients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'recipe_steps.dart';

class MyRecipes extends ConsumerWidget {
  const MyRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: const [
        RecipeIngredients(),
        RecipeSteps(),
      ],
    );
  }
}
