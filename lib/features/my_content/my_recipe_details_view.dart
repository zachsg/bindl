import 'dart:math';

import 'package:bodai/shared_controllers/providers.dart';
import 'recipe_controller.dart';
import 'recipe_info_widget.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'recipe_ingredients_widget.dart';
import 'recipe_name_widget.dart';
import 'recipe_steps_widget.dart';

class MyRecipeDetailsView extends ConsumerWidget {
  const MyRecipeDetailsView({Key? key}) : super(key: key);

  static const routeName = '/my_recipe_details';

  int _generateRandomID() {
    var random = Random();

    var digit1 = random.nextInt(9);
    var digit2 = random.nextInt(9);
    var digit3 = random.nextInt(9);
    var digit4 = random.nextInt(9);
    var digit5 = random.nextInt(9);
    var digit6 = random.nextInt(9);

    return int.parse('$digit1$digit2$digit3$digit4$digit5$digit6');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rp = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(rp.name.isEmpty ? createRecipeLabel : rp.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: saveLabel,
            onPressed: () async {
              var rp = ref.read(recipeProvider);

              if (rp.id == 0) {
                var id = _generateRandomID();

                List<int> usedIDs = [];

                ref.read(mealsProvider).forEach((element) {
                  usedIDs.add(element.id);
                });

                while (usedIDs.contains(id)) {
                  id = _generateRandomID();
                }

                rp.setID(id);
              }

              var message = await rp.validateAndSave();

              await rp.load();

              var snackBar = SnackBar(content: Text(message));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              if (message.toLowerCase() == successLabel.toLowerCase()) {
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              RecipeNameWidget(),
              RecipeInfoWidget(),
              RecipeIngredientsWidget(),
              RecipeStepsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}