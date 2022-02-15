import 'package:bodai/features/my_content/controllers/all_my_recipes_controller.dart';
import 'package:bodai/features/my_content/views/my_recipe_details_view.dart';
import 'package:bodai/features/settings/settings_view.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/recipe_controller.dart';
import '../controllers/recipe_stats_controller.dart';

final myRecipesAreCollapsedProvider = StateProvider<bool>((_) => false);

class MyRecipesView extends ConsumerStatefulWidget {
  const MyRecipesView({Key? key}) : super(key: key);

  static const routeName = '/my_recipes';

  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends ConsumerState<MyRecipesView> {
  late Future<List<Meal>> _myRecipes;

  Future<List<Meal>> _getMyRecipes() async {
    await ref.read(allRecipesProvider.notifier).load();
    await ref.read(recipeStatsProvider.notifier).load();

    return ref.watch(allRecipesProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _myRecipes = _getMyRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Meal>>(
                future: _myRecipes,
                builder: (BuildContext context2,
                    AsyncSnapshot<List<Meal>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ProgressSpinner();
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('$errorLabel: ${snapshot.error}'),
                      );
                    } else if (ref.watch(allRecipesProvider).isEmpty) {
                      return _emptyState(context);
                    } else {
                      return _recipesList(context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _createRecipButton(context),
    );
  }

  FloatingActionButton? _createRecipButton(BuildContext context) {
    if (ref.watch(allRecipesProvider).isNotEmpty) {
      return FloatingActionButton.extended(
        label: Row(
          children: [
            const Icon(Icons.add_circle),
            const SizedBox(width: 8),
            Text(
              'Create Recipe',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.white),
            )
          ],
        ),
        onPressed: () {
          ref.read(recipeProvider.notifier).resetSelf();

          Navigator.restorablePushNamed(context, MyRecipeDetailsView.routeName);
        },
      );
    }

    return null;
  }

  ListView _recipesList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      restorationId: 'sampleItemListView', // listview to restore position
      itemCount: ref.watch(allRecipesProvider).length,
      itemBuilder: (BuildContext context3, int index) {
        final recipe = ref.watch(allRecipesProvider)[index];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
          ),
          child: InkWell(
            child: ref.watch(myRecipesAreCollapsedProvider)
                ? _collapsedTile(context, index, recipe)
                : _expandedTile(index, recipe),
            onTap: () {
              ref.read(recipeProvider.notifier).setupSelf(recipe);

              Navigator.restorablePushNamed(
                context3,
                MyRecipeDetailsView.routeName,
              );
            },
          ),
        );
      },
    );
  }

  Column _emptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Recipes you create will be matched & served up to other users by their Butlers',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(recipeProvider.notifier).resetSelf();

            Navigator.restorablePushNamed(
                context, MyRecipeDetailsView.routeName);
          },
          child: const Text('Create Recipe'),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('$myLabel $creationsLabel'),
      leading: IconButton(
        icon: ref.watch(myRecipesAreCollapsedProvider)
            ? const Icon(Icons.unfold_more)
            : const Icon(Icons.unfold_less),
        onPressed: () {
          ref.read(myRecipesAreCollapsedProvider.notifier).state =
              !ref.read(myRecipesAreCollapsedProvider);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.face),
          tooltip: preferencesLabel,
          onPressed: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
      ],
    );
  }

  Column _expandedTile(int index, Meal recipe) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        index == 0 ? const SizedBox(height: 8) : const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: MealCard(meal: recipe, isMyRecipe: true),
        ),
        _comfortBox(index, ref),
      ],
    );
  }

  Padding _collapsedTile(BuildContext context, int index, Meal recipe) {
    return Padding(
      padding: _getCollapsedCardSpacePadding(index),
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: ListTile(
            title: Text(
              recipe.name,
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardFooter(context, recipe, ref),
                _commentWidget(recipe),
              ],
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets _getCollapsedCardSpacePadding(int index) {
    if (index == 0) {
      return const EdgeInsets.only(bottom: 8.0, top: 16, left: 4.0, right: 4.0);
    } else if (index == ref.watch(allRecipesProvider).length - 1) {
      return const EdgeInsets.only(
          bottom: 80.0, top: 8.0, left: 4.0, right: 4.0);
    }

    return const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0);
  }

  Widget _comfortBox(int index, WidgetRef ref) {
    var isEnd = index == ref.watch(allRecipesProvider).length - 1;
    if (isEnd) {
      return const SizedBox(height: 72);
    } else {
      return const SizedBox();
    }
  }

  Widget _cardFooter(BuildContext context, Meal meal, WidgetRef ref) {
    var rp = ref.watch(recipeStatsProvider)[meal.id];

    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.menu_book,
                color: Theme.of(context).indicatorColor.withOpacity(0.6),
              ),
              Text(
                ' In ',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).indicatorColor.withOpacity(0.6),
                    ),
              ),
              Text(
                rp?.inNumCookbooks == 1
                    ? '${rp?.inNumCookbooks ?? 0} cookbook'
                    : '${rp?.inNumCookbooks ?? 0} cookbooks',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).indicatorColor.withOpacity(0.6),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).indicatorColor.withOpacity(0.6),
              ),
              Text(
                ' $cookedXTimesLabel ',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).indicatorColor.withOpacity(0.6),
                    ),
              ),
              Text(
                rp?.numLikes == 1
                    ? '${rp?.numLikes ?? 0} time'
                    : '${rp?.numLikes ?? 0} times',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).indicatorColor.withOpacity(0.6),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.ballot_outlined,
                color: Theme.of(context).indicatorColor.withOpacity(0.6),
              ),
              Text(
                ' $currentlyInLabel ',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).indicatorColor.withOpacity(0.6),
                    ),
              ),
              Text(
                rp?.inNumOfPlans == 1
                    ? '${rp?.inNumOfPlans ?? 0} meal plan'
                    : '${rp?.inNumOfPlans ?? 0} meal plans',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).indicatorColor.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _commentWidget(Meal recipe) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton.icon(
        label: Text(
          recipe.comments.length.toString(),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
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
            builder: (BuildContext context2) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          globalDiscussionLabel,
                          style: Theme.of(context2).textTheme.headline6,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () => Navigator.pop(context2),
                        ),
                      ],
                    ),
                    Expanded(
                      child: DiscussionWidget(meal: recipe),
                    ),
                  ],
                ),
              );
            },
          );
        },
        icon: Icon(
          Icons.insert_comment,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
