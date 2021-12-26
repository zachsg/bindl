import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/models/xmodels.dart';
import 'package:bindl/screens/my_content/my_recipe_details_view.dart';
import 'package:bindl/widgets/xwidgets.dart';
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
    var up = ref.watch(userProvider);
    var rp = ref.watch(recipeProvider);
    await up.loadUserData();

    await rp.loadAllMyRecipes();

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
                    var rp = ref.watch(recipeProvider);

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (rp.allMyRecipes.isEmpty) {
                      return _loading
                          ? const ProgressSpinner()
                          : Center(
                              child: ElevatedButton(
                                child: const Text('Create Recipe'),
                                onPressed: () {
                                  ref.read(recipeProvider).resetSelf();

                                  Navigator.restorablePushNamed(
                                      context, MyRecipeDetailsView.routeName);
                                },
                              ),
                            );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          restorationId:
                              'sampleItemListView', // listview to restore position
                          itemCount: rp.allMyRecipes.length,
                          itemBuilder: (BuildContext context3, int index) {
                            final recipe = rp.allMyRecipes[index];

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
                          });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            ref.read(recipeProvider).resetSelf();

            Navigator.restorablePushNamed(
                context, MyRecipeDetailsView.routeName);
          }),
    );
  }

  Widget comfortBox(int index, WidgetRef ref) {
    var isEnd = index == ref.watch(mealPlanProvider).all.length - 1;
    if (isEnd) {
      return const SizedBox(height: 8);
    } else {
      return const SizedBox();
    }
  }
}
