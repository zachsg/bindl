import 'package:bodai/extensions.dart';
import 'package:bodai/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/xmodels.dart';
import '../pantry/pantry_controller.dart';
import '../pantry/pantry_view.dart';
import 'recipe_controller.dart';
import 'widgets/creator_button_widget.dart';

final mealStepExpandedProvider = StateProvider<bool>((_) => false);

final isMealDetailsLoadingProvider = StateProvider<bool>((_) => false);

final ownsAllIngredientsProvider = StateProvider<bool>((ref) => false);

class RecipeView extends ConsumerWidget {
  RecipeView({Key? key}) : super(key: key);

  static const routeName = '/recipe_view';

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProvider);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  expandedHeight: 280.0,
                  floating: true,
                  pinned: true,
                  snap: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        title: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7),
                          child: Row(
                            children: [
                              const SizedBox(width: 40),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Text(
                                    recipe.name,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        background: recipe.imageUrl.isEmpty
                            ? const SizedBox()
                            : Image(
                                image: NetworkImage(recipe.imageUrl),
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: PageView.builder(
                    itemCount: recipe.steps.length + 1,
                    controller: PageController(viewportFraction: 0.8),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return RecipeInfoCardWidget(
                          controller: _scrollController,
                        );
                      } else {
                        return MealStepCardWidget(
                          recipeStep: recipe.steps[index - 1],
                          recipeStepNumber: index + 1,
                          controller: _scrollController,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.70,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return IngredientsModalWidget(recipe: recipe);
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Text('Ingredients'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

final addingIngredientsToPantryProvider = StateProvider<bool>((ref) => false);

class IngredientsModalWidget extends ConsumerWidget {
  const IngredientsModalWidget({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.headline6,
              ),
              ref.watch(ownsAllIngredientsProvider)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '(All already in kitchen)',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ref.watch(addingIngredientsToPantryProvider)
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                ref
                                    .read(addingIngredientsToPantryProvider
                                        .notifier)
                                    .state = true;

                                final List<Ingredient> unownedIngredients = [];

                                final List<String> pantryStrings = [];
                                for (final i in ref.read(pantryProvider)) {
                                  pantryStrings.add(i.ingredient.name);
                                }

                                for (final i in recipe.ingredients) {
                                  if (!pantryStrings.contains(i.name)) {
                                    unownedIngredients.add(i);
                                  }
                                }

                                for (final i in unownedIngredients) {
                                  await ref
                                      .read(pantryProvider.notifier)
                                      .addIngredient(
                                        ingredient: i,
                                        toBuy: true,
                                        buyTab:
                                            ref.watch(pantryTabIndexProvider) ==
                                                1,
                                      );
                                }

                                ref
                                    .read(ownsAllIngredientsProvider.notifier)
                                    .state = true;

                                ref
                                    .read(addingIngredientsToPantryProvider
                                        .notifier)
                                    .state = false;
                              },
                              child: const Text('Add To Shopping List'),
                            ),
                    ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListView.builder(
              itemCount: recipe.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = recipe.ingredients[index];
                final measurement = ' ${ingredient.measurement.name} ';
                var formattedIngredient =
                    '${ingredient.quantity.toFractionString()}'
                    '${ingredient.measurement == IngredientMeasure.item ? ' ' : measurement}'
                    '${ingredient.name}';

                if (ingredient.preparationMethod.isNotEmpty) {
                  formattedIngredient += ', ${ingredient.preparationMethod}';
                }

                if (ingredient.isOptional) {
                  formattedIngredient += ' (optional)';
                }

                return ListTile(
                  dense: true,
                  title: Text(
                    formattedIngredient,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MealStepCardWidget extends ConsumerWidget {
  const MealStepCardWidget({
    Key? key,
    required this.recipeStep,
    required this.recipeStepNumber,
    required this.controller,
  }) : super(key: key);

  final RecipeStep recipeStep;
  final int recipeStepNumber;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width / 1.3,
        child: GestureDetector(
          onTap: () {
            ref.read(mealStepExpandedProvider.notifier).state =
                !ref.read(mealStepExpandedProvider);

            _expandCard(ref);
          },
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            elevation: 4,
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('$recipeStepNumber'),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 64,
                        bottom: 16,
                      ),
                      child: recipeStep.tip.isEmpty
                          ? SingleChildScrollView(
                              child: Text(
                                recipeStep.step.trim(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontSize: 16),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    recipeStep.step.trim(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    recipeStep.tip.trim(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _expandCard(WidgetRef ref) {
    if (ref.watch(mealStepExpandedProvider)) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    } else {
      controller.animateTo(
        controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    }
  }
}

class RecipeInfoCardWidget extends ConsumerWidget {
  const RecipeInfoCardWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProvider);

    final allergies = recipe.allergies.asNameMap().keys;
    final allergiesCap = [];
    for (var element in allergies) {
      if (element == 'treeNuts') {
        allergiesCap.add('Tree nuts');
      } else {
        allergiesCap.add(element.capitalize());
      }
    }

    final appliances = recipe.appliances.asNameMap().keys;
    final appliancesCap = [];
    for (var element in appliances) {
      if (element == 'airFryer') {
        appliancesCap.add('Air fryer');
      } else if (element == 'instantPot') {
        appliancesCap.add('Instant pot');
      } else {
        appliancesCap.add(element.capitalize());
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width / 1.3,
        child: GestureDetector(
          onTap: () {
            ref.read(mealStepExpandedProvider.notifier).state =
                !ref.read(mealStepExpandedProvider);

            _expandCard(ref);
          },
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            elevation: 4,
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('1'),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 64,
                      bottom: 16,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Creator',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              CreatorButtonWidget(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RecipeInfoCardItemWidget(
                                label: 'Prep Time',
                                value: '${recipe.prepTime} min',
                              ),
                              RecipeInfoCardItemWidget(
                                label: 'Cook Time',
                                value: '${recipe.cookTime} min',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RecipeInfoCardItemWidget(
                                label: 'Servings',
                                value: '${recipe.servings}',
                              ),
                              RecipeInfoCardItemWidget(
                                label: 'Ingredients',
                                value: '${recipe.ingredients.length}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RecipeInfoCardItemWidget(
                                label: 'Diet',
                                value: recipe.diet.name.capitalize(),
                              ),
                              RecipeInfoCardItemWidget(
                                label: 'Cuisine',
                                value: recipe.cuisine.name.capitalize(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RecipeInfoCardItemWidget(
                            label: 'Allergies',
                            value: recipe.allergies.isEmpty
                                ? 'None'
                                : allergiesCap.join(', '),
                          ),
                          const SizedBox(height: 16),
                          RecipeInfoCardItemWidget(
                            label: 'Appliances',
                            value: recipe.appliances.isEmpty
                                ? 'None'
                                : appliancesCap.join(', '),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _expandCard(WidgetRef ref) {
    if (ref.watch(mealStepExpandedProvider)) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    } else {
      controller.animateTo(
        controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    }
  }
}

class RecipeInfoCardItemWidget extends StatelessWidget {
  const RecipeInfoCardItemWidget({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}
