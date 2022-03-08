import 'package:bodai/features/profile/edit_recipe_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/ingredients.dart';
import '../../../models/ingredient.dart';
import '../../../models/ingredient_category.dart';
import '../../../models/ingredient_measure.dart';

final recipeQuantityProvider = StateProvider<double>((ref) => 0.0);
final recipeIngredientProvider = StateProvider<Ingredient>((ref) =>
    const Ingredient(id: -1, name: '', category: IngredientCategory.oils));
final recipeMeasureProvider =
    StateProvider<IngredientMeasure>((ref) => IngredientMeasure.oz);

class RecipeIngredientsWidget extends HookConsumerWidget {
  const RecipeIngredientsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _quantityController = useTextEditingController();
    final _ingredientController = useTextEditingController();

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
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SizedBox(
                width: 75,
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (quantity) => ref
                      .read(recipeQuantityProvider.notifier)
                      .state = double.tryParse(quantity) ?? 0.0,
                  decoration: const InputDecoration(
                    labelText: 'Qty',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            DropdownButton<IngredientMeasure>(
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
              items:
                  IngredientMeasure.values.map((IngredientMeasure classType) {
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
            ),
            const SizedBox(width: 4),
            Expanded(
              child: TypeAheadFormField(
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
                  return Ingredients.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion as String));
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) async {
                  _ingredientController.text = suggestion as String;
                  ref.read(recipeIngredientProvider.notifier).state =
                      Ingredients.all.firstWhere((ingredient) =>
                          ingredient.name == suggestion.toLowerCase());
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
              ),
            ),
            IconButton(
              onPressed: () {
                ref.read(editRecipeProvider.notifier).addIngredientWith(
                    ref.read(recipeIngredientProvider),
                    ref.read(recipeQuantityProvider),
                    ref.read(recipeMeasureProvider));
                _ingredientController.clear();
                _quantityController.clear();
              },
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
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
        title: Text(
            '${ingredient.quantity} ${ingredient.measurement.name} ${ingredient.name}'),
      ),
    );
  }
}
