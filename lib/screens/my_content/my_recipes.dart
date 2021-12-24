import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/screens/my_content/recipe_info.dart';
import 'package:bindl/screens/my_content/recipe_ingredients.dart';
import 'package:bindl/screens/my_content/recipe_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'recipe_steps.dart';

class MyRecipes extends ConsumerWidget {
  const MyRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          RecipeName(),
          RecipeInfo(),
          RecipeIngredients(),
          RecipeSteps(),
        ],
      ),
    );
  }
}
