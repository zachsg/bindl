import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bodai/extensions.dart';

import '../../../../data/ingredients.dart';
import '../../../../models/ingredient.dart';
import '../../../../models/ingredient_category.dart';
import '../../../../models/ingredient_measure.dart';
import '../edit_recipe_controller.dart';

final recipeQuantityProvider = StateProvider<double>((ref) => 0.0);

final recipeIngredientProvider = StateProvider<Ingredient>((ref) =>
    const Ingredient(id: -1, name: '', category: IngredientCategory.oils));

final recipeMeasureProvider =
    StateProvider<IngredientMeasure>((ref) => IngredientMeasure.oz);

final recipePreparationMethodProvider = StateProvider<String>((ref) => '');

final recipeIngredientIsOptionalProvider = StateProvider<bool>((ref) => false);

final randomId = Random(600);

class RecipeIngredientsWidget extends HookConsumerWidget {
  const RecipeIngredientsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _quantityController = useTextEditingController();
    final _ingredientController = useTextEditingController();
    final _methodController = useTextEditingController();

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
                            quantityController: _quantityController),
                      ),
                      const SizedBox(width: 4),
                      const IngredientMeasureDropdownButtonWidget(),
                      const SizedBox(width: 4),
                      Flexible(
                        flex: 2,
                        child: IngredientTextField(
                            ingredientController: _ingredientController),
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
                            methodController: _methodController),
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
                  final random = randomId.nextInt(10000);

                  ref.read(recipeIngredientProvider.notifier).state = ref
                      .read(recipeIngredientProvider)
                      .copyWith(
                          id: random,
                          category: IngredientCategory.misc,
                          name:
                              _ingredientController.text.toLowerCase().trim());
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
                _ingredientController.clear();
                _quantityController.clear();
                _methodController.clear();
                ref.read(recipeIngredientIsOptionalProvider.notifier).state =
                    false;
                ref.read(recipePreparationMethodProvider.notifier).state = '';
                ref.read(recipeQuantityProvider.notifier).state = 0.0;
                ref.read(recipeIngredientProvider.notifier).state =
                    const Ingredient(
                        id: -1, name: '', category: IngredientCategory.oils);
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
    Key? key,
    required TextEditingController methodController,
  })  : _methodController = methodController,
        super(key: key);

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
    Key? key,
    required TextEditingController quantityController,
  })  : _quantityController = quantityController,
        super(key: key);

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
  const IngredientMeasureDropdownButtonWidget({
    Key? key,
  }) : super(key: key);

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
            classType.name,
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
    Key? key,
    required TextEditingController ingredientController,
  })  : _ingredientController = ingredientController,
        super(key: key);

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
        return Ingredients.getSuggestions(pattern, ref);
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
  const RecipeIngredientsListWidget({Key? key}) : super(key: key);

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
  const RecipeDismissibleIngredientWidget({Key? key, required this.index})
      : super(key: key);

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
          children: const [
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.delete, color: Colors.white),
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
            Text(
                '${ingredient.quantity.toFractionString()} ${ingredient.measurement.name} ${ingredient.name}'
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
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
    Key? key,
    required this.ingredient,
    required this.index,
  }) : super(key: key);

  final Ingredient ingredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _quantityController = useTextEditingController(
        text: ingredient.quantity == 0.0 ? '' : ingredient.quantity.toString());
    final _ingredientController =
        useTextEditingController(text: ingredient.name);
    final _methodController =
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
                    quantityController: _quantityController),
              ),
              const SizedBox(width: 4),
              const IngredientMeasureDropdownButtonWidget(),
              const SizedBox(width: 4),
              Flexible(
                flex: 2,
                child: IngredientTextField(
                    ingredientController: _ingredientController),
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
                    methodController: _methodController),
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
                      name: _ingredientController.text.toLowerCase().trim());
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