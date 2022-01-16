import 'package:bodai/controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/screens/my_content/my_recipe_details_view.dart';
import 'package:bodai/screens/settings/settings_view.dart';
import 'package:bodai/utils/strings.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyRecipesView extends ConsumerStatefulWidget {
  const MyRecipesView({Key? key}) : super(key: key);

  static const routeName = '/my_recipes';

  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends ConsumerState<MyRecipesView> {
  late Future<List<Meal>> _myRecipes;
  bool _loading = false;

  Future<List<Meal>> _getMyRecipes() async {
    var rp = ref.watch(recipeProvider);

    await rp.loadAllMyRecipes();

    await rp.loadAllMyStats();

    return rp.allMyRecipes;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _myRecipes = _getMyRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$myLabel $creationsLabel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.face),
            tooltip: preferencesLabel,
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
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
                    } else if (ref.watch(recipeProvider).allMyRecipes.isEmpty) {
                      return _loading
                          ? const ProgressSpinner()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Create recipes for other users\' Butlers suggest to them!',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              ],
                            );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        restorationId:
                            'sampleItemListView', // listview to restore position
                        itemCount:
                            ref.watch(recipeProvider).allMyRecipes.length,
                        itemBuilder: (BuildContext context3, int index) {
                          final recipe =
                              ref.watch(recipeProvider).allMyRecipes[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: GestureDetector(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  index == 0
                                      ? const SizedBox(height: 8)
                                      : const SizedBox(),
                                  MealCard(meal: recipe, isMyRecipe: true),
                                  comfortBox(index, ref),
                                ],
                              ),
                              onTap: () {
                                ref.read(recipeProvider).setupSelf(recipe);

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
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
            ref.read(recipeProvider).resetSelf();

            Navigator.restorablePushNamed(
                context, MyRecipeDetailsView.routeName);
          }),
    );
  }

  Widget comfortBox(int index, WidgetRef ref) {
    var isEnd = index == ref.watch(recipeProvider).allMyRecipes.length - 1;
    if (isEnd) {
      return const SizedBox(height: 72);
    } else {
      return const SizedBox();
    }
  }
}
