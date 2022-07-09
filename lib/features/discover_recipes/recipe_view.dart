import 'package:bodai/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/xmodels.dart';
import '../../providers/providers.dart';
import '../pantry/pantry_controller.dart';
import 'discover_recipes_controller.dart';
import 'recipe_controller.dart';
import 'widgets/creator_button_widget.dart';

final mealStepExpandedProvider = StateProvider<bool>((_) => false);

class RecipeView extends ConsumerWidget {
  RecipeView({super.key, required this.recipe});

  static const routeName = 'recipe_view';

  final Recipe recipe;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                              .background
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
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        background: recipe.imageUrl.isEmpty
                            ? const SizedBox()
                            : CachedNetworkImage(
                                imageUrl: recipe.imageUrl,
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.restaurant_menu),
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
                    onPageChanged: (pageNumber) {
                      ref
                          .read(showingIngredientsButtonProvider.notifier)
                          .state = pageNumber != recipe.steps.length + 1;
                    },
                    itemCount: ref.read(hasAllIngredientsInFridgeProvider)
                        ? recipe.steps.length + 2
                        : recipe.steps.length + 1,
                    controller: PageController(viewportFraction: 0.8),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return RecipeInfoCardWidget(
                          controller: _scrollController,
                        );
                      } else if (index > 0 && index < recipe.steps.length + 1) {
                        return MealStepCardWidget(
                          recipeStep: recipe.steps[index - 1],
                          recipeStepNumber: index + 1,
                          controller: _scrollController,
                        );
                      } else {
                        return RecipeDoneCardWidget(
                            controller: _scrollController);
                      }
                    },
                  ),
                ),
              ),
            ),
            ref.watch(showingIngredientsButtonProvider)
                ? ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.70,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return IngredientsModalWidget(recipe: recipe);
                        },
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      child: Text('Ingredients'),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

final addingIngredientsToPantryProvider = StateProvider<bool>((ref) => false);

class IngredientsModalWidget extends ConsumerWidget {
  const IngredientsModalWidget({super.key, required this.recipe});

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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  ref.watch(ownsAllIngredientsProvider)
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ref.watch(addingIngredientsToPantryProvider)
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () async {
                                    await ref
                                        .read(recipeProvider.notifier)
                                        .addIngredientsToPantry(recipe);

                                    ref
                                        .read(
                                            ownsAllIngredientsProvider.notifier)
                                        .state = true;
                                  },
                                  child: const Text('Add To Shopping List'),
                                ),
                        ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              ref.watch(ownsAllIngredientsProvider)
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            'All ingredients are currently in your pantry / shopping list',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()
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
                final measurement = ' ${ingredient.measurement.name} '
                    .replaceAll('toTaste', 'to taste');
                var formattedIngredient = ingredient.quantity == 0.0
                    ? ''
                    : ingredient.quantity.toFractionString();
                formattedIngredient +=
                    '${ingredient.measurement == IngredientMeasure.ingredient ? ' ' : measurement}'
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
                    ingredient.measurement == IngredientMeasure.toTaste
                        ? '${ingredient.name} to taste'
                        : formattedIngredient,
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
    super.key,
    required this.recipeStep,
    required this.recipeStepNumber,
    required this.controller,
  });

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
  const RecipeInfoCardWidget({super.key, required this.controller});

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
      } else if (element == 'mortarAndPestle') {
        appliancesCap.add('Mortar & Pestle');
      } else {
        appliancesCap.add(element.capitalize());
      }
    }

    final dietStrings = [];
    for (final d in recipe.diets) {
      dietStrings.add(d.name.capitalize());
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
                                values: ['${recipe.prepTime} min'],
                              ),
                              RecipeInfoCardItemWidget(
                                label: 'Cook Time',
                                values: ['${recipe.cookTime} min'],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RecipeInfoCardItemWidget(
                                label: 'Servings',
                                values: ['${recipe.servings}'],
                              ),
                              RecipeInfoCardItemWidget(
                                label: 'Ingredients',
                                values: ['${recipe.ingredients.length}'],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 1,
                                child: RecipeInfoCardItemWidget(
                                  label:
                                      dietStrings.length > 1 ? 'Diets' : 'Diet',
                                  values: List.from(dietStrings),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: RecipeInfoCardItemWidget(
                                  label: 'Cuisine',
                                  values: [recipe.cuisine.name.capitalize()],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RecipeInfoCardItemWidget(
                            label: 'Allergies',
                            values: recipe.allergies.isEmpty
                                ? ['None']
                                : List.from(allergiesCap),
                          ),
                          const SizedBox(height: 16),
                          RecipeInfoCardItemWidget(
                            label: 'Appliances',
                            values: recipe.appliances.isEmpty
                                ? ['None']
                                : List.from(appliancesCap),
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
    super.key,
    required this.label,
    required this.values,
  });

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        Column(
          children: [
            for (final value in values)
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 16),
              ),
          ],
        ),
      ],
    );
  }
}

class RecipeDoneCardWidget extends ConsumerWidget {
  const RecipeDoneCardWidget({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProvider);

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
          child: ref.watch(markCookedIsDirtyProvider)
              ? Center(
                  child: Text(
                    'Yay! You cooked ${recipe.name}. Nice work 🎉',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 16),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You made it! Mark this meal as cooked... if you cooked it 😉',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ref.watch(addingIngredientsToPantryProvider)
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              // const title = 'I Cooked It!';
                              // const widget = Text('Mark this meal as cooked and '
                              //     'deduct the appropriate ingredients '
                              //     '(and quantities) from your pantry?');

                              // _showMyDialog(context, title, widget, ref, recipe);

                              ref
                                  .read(addingIngredientsToPantryProvider
                                      .notifier)
                                  .state = true;

                              final List<int> fridgeIds = [];
                              for (final i in ref.read(fridgeProvider)) {
                                fridgeIds.add(i.ingredient.id);
                              }

                              for (final i in recipe.ingredients) {
                                if (fridgeIds.contains(i.id)) {
                                  final i2 = ref
                                      .read(pantryProvider.notifier)
                                      .ingredientWithId(i.id)
                                      .ingredient;

                                  await ref
                                      .read(pantryProvider.notifier)
                                      .subtractIngredientQuantities(i2, i);
                                }
                              }

                              await ref
                                  .read(recipeProvider.notifier)
                                  .markCooked();

                              ref
                                  .read(pantryProvider.notifier)
                                  .ingredientsInPantryFrom(recipe);

                              ref
                                  .read(pantryProvider.notifier)
                                  .ingredientsInFridgeFrom(recipe);

                              await ref.read(pantryProvider.notifier).load();

                              ref.refresh(recipesFutureProvider);

                              ref
                                  .read(markCookedIsDirtyProvider.notifier)
                                  .state = true;

                              ref
                                  .read(addingIngredientsToPantryProvider
                                      .notifier)
                                  .state = false;
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text('I Cooked It'),
                            ),
                          ),
                  ],
                ),
          // Card(
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(8),
          //     ),
          //   ),
          //   elevation: 4,
          //   child: Stack(
          //     children: [
          //       Positioned(
          //         top: 16,
          //         left: 8,
          //         child: Container(
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             border: Border.all(
          //               color: Theme.of(context).colorScheme.primary,
          //               width: 2,
          //             ),
          //           ),
          //           child: const Padding(
          //             padding: EdgeInsets.all(6.0),
          //             child: Text('✔️'),
          //           ),
          //         ),
          //       ),
          //       Positioned.fill(
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //             left: 16,
          //             right: 16,
          //             top: 64,
          //             bottom: 16,
          //           ),
          //           child: SingleChildScrollView(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Column(
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Text(
          //                       'You made it! Mark this meal as cooked (if you cooked it ;)).',
          //                       style: TextStyle(
          //                           color: Theme.of(context)
          //                               .colorScheme
          //                               .secondary),
          //                     ),
          //                     const SizedBox(height: 16),
          //                     ElevatedButton(
          //                       onPressed: () {},
          //                       child: Text('Mark Cooked'),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
