import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/screens/my_content/recipe_info.dart';
import 'package:bindl/screens/my_content/recipe_ingredients.dart';
import 'package:bindl/screens/my_content/recipe_name.dart';
import 'package:bindl/screens/my_content/recipe_steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyRecipeDetailsView extends ConsumerWidget {
  const MyRecipeDetailsView({Key? key}) : super(key: key);

  static const routeName = '/my_recipe_details';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rp = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(rp.name.isEmpty ? 'Create Recipe' : rp.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () async {
              var rp = ref.read(recipeProvider);

              if (rp.id == 0) {
                var allMeals = await rp.allMeals();
                rp.setID(allMeals.length * 20);
              }

              var message = await rp.validateAndSave();

              await rp.loadAllMyRecipes();

              var snackBar = SnackBar(content: Text(message));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              RecipeName(),
              RecipeInfo(),
              RecipeIngredients(),
              RecipeSteps(),
            ],
          ),
        ),
      ),
    );
  }
}
