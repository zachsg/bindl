import 'dart:math';

import 'package:bodai/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/ingredients.dart';
import '../../../../models/ingredient.dart';
import '../../../../models/ingredient_category.dart';
import '../../../../models/ingredient_measure.dart';
import '../edit_recipe_controller.dart';

final randomId = Random(600);

class RecipeIngredientsWidget extends HookConsumerWidget {
  const RecipeIngredientsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantityController = useTextEditingController();
    final ingredientController = useTextEditingController();
    final methodController = useTextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Recipe ingredients',
            style: TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(height: 8),
        const RecipeIngredientsListWidget(),
        const SizedBox(height: 8),
        Row(
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: IngredientQuantityTextFieldWidget(
                            quantityController: quantityController),
                      ),
                      const SizedBox(width: 4),
                      const IngredientMeasureDropdownButtonWidget(),
                      const SizedBox(width: 4),
                      Flexible(
                        flex: 2,
                        child: IngredientTextField(
                            ingredientController: ingredientController),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: IngredientPreparationMethodTextFieldWidget(
                            methodController: methodController),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Switch(
                            value:
                                ref.watch(recipeIngredientIsOptionalProvider),
                            onChanged: (isOptional) {
                              ref
                                  .read(recipeIngredientIsOptionalProvider
                                      .notifier)
                                  .state = isOptional;
                            },
                          ),
                          const Text('Optional?'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                if (!Ingredients.all
                    .contains(ref.read(recipeIngredientProvider))) {
                  final i = Ingredients.all.firstWhere(
                      (element) =>
                          element.name ==
                          ingredientController.text.toLowerCase().trim(),
                      orElse: () {
                    final random = randomId.nextInt(10000);

                    return ref.read(recipeIngredientProvider).copyWith(
                        id: random,
                        category: IngredientCategory.misc,
                        name: ingredientController.text.toLowerCase().trim());
                  });

                  ref.read(recipeIngredientProvider.notifier).state = i;
                }

                bool ingredientAlreadyUsed = false;
                for (final i in ref.read(editRecipeProvider).ingredients) {
                  if (i.id == ref.read(recipeIngredientProvider).id) {
                    ingredientAlreadyUsed = true;
                    break;
                  }
                }

                if (ingredientAlreadyUsed) {
                  final snackBar = SnackBar(
                    content: Text(
                        '${ref.read(recipeIngredientProvider).name.capitalize()} is already in this recipe.'
                        '\n\nDelete it first and re-add if you need to make changes!'),
                  );
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                ref.read(editRecipeProvider.notifier).addIngredientWith(
                      ref.read(recipeIngredientProvider),
                      ref.read(recipeQuantityProvider),
                      ref.read(recipeMeasureProvider),
                      ref.read(recipePreparationMethodProvider),
                      ref.read(recipeIngredientIsOptionalProvider),
                    );
                ingredientController.clear();
                quantityController.clear();
                methodController.clear();
                ref.read(recipeIngredientIsOptionalProvider.notifier).state =
                    false;
                ref.read(recipePreparationMethodProvider.notifier).state = '';
                ref.read(recipeQuantityProvider.notifier).state = 0.0;
                ref.read(recipeIngredientProvider.notifier).state =
                    const Ingredient(
                        id: -1, name: '', category: IngredientCategory.oils);

                ref.read(recipeNeedsSavingProvider.notifier).state = true;
              },
              icon: Icon(
                Icons.add_circle,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class IngredientPreparationMethodTextFieldWidget extends ConsumerWidget {
  const IngredientPreparationMethodTextFieldWidget({
    super.key,
    required TextEditingController methodController,
  }) : _methodController = methodController;

  final TextEditingController _methodController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: TextFormField(
        controller: _methodController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.none,
        minLines: 1,
        maxLines: 3,
        onChanged: (preparationMethod) => ref
            .read(recipePreparationMethodProvider.notifier)
            .state = preparationMethod,
        decoration: const InputDecoration(
          labelText: 'Preparation method',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class IngredientQuantityTextFieldWidget extends ConsumerWidget {
  const IngredientQuantityTextFieldWidget({
    super.key,
    required TextEditingController quantityController,
  }) : _quantityController = quantityController;

  final TextEditingController _quantityController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: TextFormField(
        controller: _quantityController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (quantity) => ref
            .read(recipeQuantityProvider.notifier)
            .state = double.tryParse(quantity) ?? 0.0,
        decoration: const InputDecoration(
          labelText: 'Qty',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class IngredientMeasureDropdownButtonWidget extends ConsumerWidget {
  const IngredientMeasureDropdownButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton<IngredientMeasure>(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      icon: const SizedBox.shrink(),
      iconSize: 0.0,
      underline: const SizedBox(),
      value: ref.watch(recipeMeasureProvider),
      onChanged: (measurement) {
        if (measurement != null) {
          ref.read(recipeMeasureProvider.notifier).state = measurement;
        }
      },
      items: IngredientMeasure.values.map((IngredientMeasure classType) {
        return DropdownMenuItem<IngredientMeasure>(
          value: classType,
          child: Text(
            classType.name == 'toTaste' ? 'to taste' : classType.name,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class IngredientTextField extends ConsumerWidget {
  const IngredientTextField({
    super.key,
    required TextEditingController ingredientController,
  }) : _ingredientController = ingredientController;

  final TextEditingController _ingredientController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _ingredientController,
        scrollPadding: const EdgeInsets.only(bottom: 300),
        maxLines: 2,
        minLines: 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Ingredient',
        ),
      ),
      suggestionsCallback: (pattern) {
        return Ingredients.getSuggestionsRecipe(pattern, ref);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion as String));
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) async {
        _ingredientController.text = suggestion as String;
        ref.read(recipeIngredientProvider.notifier).state = Ingredients.all
            .firstWhere(
                (ingredient) => ingredient.name == suggestion.toLowerCase());
      },
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Ingredient';
        }

        return value;
      },
      onSaved: (value) async {
        if (value != null) {
          _ingredientController.text = value;
        }
      },
    );
  }
}

class RecipeIngredientsListWidget extends ConsumerWidget {
  const RecipeIngredientsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReorderableListView(
      key: UniqueKey(),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        for (int index = 0;
            index < ref.watch(editRecipeProvider).ingredients.length;
            index++)
          Container(
            key: ValueKey(ref.watch(editRecipeProvider).ingredients[index].id),
            child: RecipeDismissibleIngredientWidget(index: index),
          )
      ],
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = ref
            .read(editRecipeProvider.notifier)
            .removeIngredientAtIndex(oldIndex);
        ref
            .read(editRecipeProvider.notifier)
            .insertIngredientAtIndex(newIndex, item);
      },
    );
  }
}

class RecipeDismissibleIngredientWidget extends ConsumerWidget {
  const RecipeDismissibleIngredientWidget({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredient = ref.watch(editRecipeProvider).ingredients[index];

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        ref.read(editRecipeProvider.notifier).removeIngredientAtIndex(index);
      },
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
      child: ListTile(
        key: Key('$index'),
        trailing: const Icon(Icons.reorder),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ingredient.measurement == IngredientMeasure.toTaste
                ? Text('${ingredient.name} to taste')
                : Text(ingredient.measurement == IngredientMeasure.ingredient
                    ? '${ingredient.quantity.toFractionString()} ${ingredient.name}'
                    : '${ingredient.quantity.toFractionString()} ${ingredient.measurement.name} ${ingredient.name}'
                        '${ingredient.preparationMethod.isEmpty ? '' : ', ${ingredient.preparationMethod}'}'
                        '${ingredient.isOptional ? ' (optional)' : ''}'),
          ],
        ),
        onTap: () {
          ref.read(recipeIngredientIsOptionalProvider.notifier).state =
              ingredient.isOptional;
          ref.read(recipeIngredientProvider.notifier).state = ingredient;
          ref.read(recipeQuantityProvider.notifier).state = ingredient.quantity;
          ref.read(recipeMeasureProvider.notifier).state =
              ingredient.measurement;
          ref.read(recipePreparationMethodProvider.notifier).state =
              ingredient.preparationMethod;

          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding: const EdgeInsets.all(8.0),
                contentPadding: const EdgeInsets.only(
                  right: 16.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                title: const Text('Edit Ingredient'),
                content: SingleChildScrollView(
                  child: RecipeIngredientEntryWidget(
                    ingredient: ingredient,
                    index: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RecipeIngredientEntryWidget extends HookConsumerWidget {
  const RecipeIngredientEntryWidget({
    super.key,
    required this.ingredient,
    required this.index,
  });

  final Ingredient ingredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantityController = useTextEditingController(
        text: ingredient.quantity == 0.0 ? '' : ingredient.quantity.toString());
    final ingredientController =
        useTextEditingController(text: ingredient.name);
    final methodController =
        useTextEditingController(text: ingredient.preparationMethod);

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.87,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: IngredientQuantityTextFieldWidget(
                    quantityController: quantityController),
              ),
              const SizedBox(width: 4),
              const IngredientMeasureDropdownButtonWidget(),
              const SizedBox(width: 4),
              Flexible(
                flex: 2,
                child: IngredientTextField(
                    ingredientController: ingredientController),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.87,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: IngredientPreparationMethodTextFieldWidget(
                    methodController: methodController),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Switch(
                    value: ref.watch(recipeIngredientIsOptionalProvider),
                    onChanged: (isOptional) {
                      ref
                          .read(recipeIngredientIsOptionalProvider.notifier)
                          .state = isOptional;
                    },
                  ),
                  const Text('Optional?'),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (!Ingredients.all.contains(ref.read(recipeIngredientProvider))) {
              final random = randomId.nextInt(10000);

              ref.read(recipeIngredientProvider.notifier).state = ref
                  .read(recipeIngredientProvider)
                  .copyWith(
                      id: random,
                      category: IngredientCategory.misc,
                      name: ingredientController.text.toLowerCase().trim());
            }

            ref
                .read(editRecipeProvider.notifier)
                .updateIngredientAtIndex(index);

            ref.read(recipeIngredientIsOptionalProvider.notifier).state = false;

            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: Text('Done'),
          ),
        ),
      ],
    );
  }
}
