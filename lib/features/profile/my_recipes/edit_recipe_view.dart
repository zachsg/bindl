import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/providers.dart';
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
  const EditRecipeView({super.key});

  static const routeName = '/edit_recipe';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        if (ref.read(recipeNeedsSavingProvider)) {
          const widget = Text('You made changes. Do you want to save them?');
          _showMyDialog(context, 'Save Changes?', widget, ref);
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            ref.watch(editRecipeProvider).name.isEmpty
                ? 'Create Recipe'
                : ref.watch(editRecipeProvider).name,
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                final message = await ref
                    .read(editRecipeProvider.notifier)
                    .validateAndSave();

                final snackBar = SnackBar(content: Text(message));
                scaffoldMessenger.removeCurrentSnackBar();
                scaffoldMessenger.showSnackBar(snackBar);

                ref.read(recipeNeedsSavingProvider.notifier).state = false;

                if (message == 'Recipe saved') {
                  navigator.pop();
                }
              },
              child: const Text('Save'),
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
                      ],
                    ),
                  ],
                ),
                const RecipeDietWidget(),
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
      ),
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, String title, Widget widget, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: widget),
          actions: <Widget>[
            TextButton(
              child: const Text('Discard'),
              onPressed: () {
                ref.read(recipeNeedsSavingProvider.notifier).state = false;
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Keep Editing'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save!'),
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                final message = await ref
                    .read(editRecipeProvider.notifier)
                    .validateAndSave();

                final snackBar = SnackBar(content: Text(message));
                scaffoldMessenger.removeCurrentSnackBar();
                scaffoldMessenger.showSnackBar(snackBar);

                ref.read(recipeNeedsSavingProvider.notifier).state = false;
                navigator.pop();
                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
