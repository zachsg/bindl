import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'edit_recipe_controller.dart';
import 'widgets/recipe_allergies_widget.dart';
import 'widgets/recipe_appliances_widget.dart';
import 'widgets/recipe_cook_time_widget.dart';
import 'widgets/recipe_cuisine_widget.dart';
import 'widgets/recipe_diet_widget.dart';
import 'widgets/recipe_ingredients_widget.dart';
import 'widgets/recipe_name_text_field_widget.dart';
import 'widgets/recipe_photo_widget.dart';
import 'widgets/recipe_prep_time_widget.dart';
import 'widgets/recipe_recipe_type_widget.dart';
import 'widgets/recipe_servings_widget.dart';
import 'widgets/recipe_steps_widget.dart';

class EditRecipeView extends ConsumerWidget {
  const EditRecipeView({Key? key}) : super(key: key);

  static const routeName = '/edit_recipe';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(editRecipeProvider).name.isEmpty
              ? 'Create Recipe'
              : ref.watch(editRecipeProvider).name,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              //TODO: Create recipe and navigate back to profile
              final message =
                  await ref.read(editRecipeProvider.notifier).validateAndSave();

              final snackBar = SnackBar(content: Text(message));
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              if (message == 'Recipe saved') {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              const RecipeNameTextFieldWidget(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  RecipePrepTimeWidget(),
                  RecipeCookTimeWidget(),
                  RecipeServingsWidget(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const RecipePhotoWidget(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      RecipeCuisineWidget(),
                      RecipeRecipeTypeWidget(),
                      RecipeDietWidget(),
                    ],
                  ),
                ],
              ),
              const RecipeAllergiesWidget(),
              const RecipeAppliancesWidget(),
              const RecipeIngredientsWidget(),
              const SizedBox(height: 24),
              const RecipeStepsWidget(),
              const SizedBox(height: 92),
            ],
          ),
        ),
      ),
    );
  }
}
