import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../../providers/providers.dart';
import '../../pantry/pantry_controller.dart';
import '../recipe_controller.dart';
import '../recipe_view.dart';

class RecipeCardWidget extends ConsumerWidget {
  const RecipeCardWidget({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final percentageOwned = ref
        .read(recipeProvider.notifier)
        .percentageOfIngredientsAlreadyOwned(recipe: recipe, inPantry: true);

    final percentageShopping = ref
        .read(recipeProvider.notifier)
        .percentageOfIngredientsAlreadyOwned(recipe: recipe, inPantry: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          ref.read(pantryProvider.notifier).ingredientsInPantryFrom(recipe);
          ref.read(pantryProvider.notifier).ingredientsInFridgeFrom(recipe);
          ref.read(showingIngredientsButtonProvider.notifier).state = true;
          ref.read(markCookedIsDirtyProvider.notifier).state = false;
          ref.read(recipeProvider.notifier).setupSelf(recipe);

          context.pushNamed(
            RecipeView.routeName,
            params: {'id': recipe.id.toString()},
            extra: recipe,
          );
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: recipe.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.restaurant_menu),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: Container(
                          height: 36,
                          width: 48,
                          color: Theme.of(context).colorScheme.background,
                          child: percentageShopping + percentageOwned >= 1
                              ? IconButton(
                                  onPressed: () {
                                    const snackBar = SnackBar(
                                      content: Text(
                                          'All of the ingredients are already either in your pantry or shopping list.'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    size: 22,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    const title = 'Add To Shopping List';
                                    const widget = Text(
                                        'Do you want to add the '
                                        'missing ingredients to your shopping list?');

                                    _showMyDialog(
                                        context, title, widget, ref, recipe);
                                  },
                                  icon: const Icon(
                                    Icons.shopping_basket,
                                    size: 22,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    percentageOwned >= .8
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10)),
                              child: Container(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2, top: 2, right: 6),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 16,
                                        ),
                                        Text(
                                          'Top Match',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ))
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 2.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      recipe.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 2.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.prepTime + recipe.cookTime}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      'min',
                      style: TextStyle(
                        fontSize: 8,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.restaurant, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.ingredients.length}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        'ingredients',
                        style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                top: 2.0,
                bottom: 4.0,
              ),
              child: Row(
                children: [
                  const Icon(Icons.kitchen, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${(percentageOwned * 100).floor()}%',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.shopping_basket_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${(percentageShopping * 100).ceil()}%',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String title, Widget widget,
      WidgetRef ref, Recipe recipe) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: widget),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add Ingredients'),
              onPressed: () async {
                Navigator.of(context).pop();

                await ref
                    .read(recipeProvider.notifier)
                    .addIngredientsToPantry(recipe);
              },
            ),
          ],
        );
      },
    );
  }
}
