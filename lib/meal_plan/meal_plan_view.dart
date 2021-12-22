import 'package:bindl/settings/settings_view.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meal.dart';
import 'meal_plan_details_view.dart';

class MealPlanView extends ConsumerStatefulWidget {
  const MealPlanView({Key? key}) : super(key: key);

  static const routeName = '/meal_plan';

  @override
  _MealPlanView createState() => _MealPlanView();
}

class _MealPlanView extends ConsumerState<MealPlanView> {
  late Future<List<Meal>> _mealPlan;
  bool _loading = false;

  Future<List<Meal>> _getMealPlan() async {
    var up = ref.watch(userProvider);
    var mp = ref.watch(mealPlanProvider);
    await up.loadUserData();

    if (up.recipes.isEmpty) {
      await up.computeMealPlan();
    }

    if (mp.showingNew) {
      await mp.loadMealsForIDs(up.recipes);
    } else {
      var ids = up.recipesLiked + up.recipesDisliked;

      await mp.loadMealsForIDs(ids.toSet().toList());
    }

    ref.read(shoppingListProvider).buildUnifiedShoppingList();

    return mp.all;
  }

  Future<void> _refresh() async {
    var up = ref.watch(userProvider);
    var mp = ref.watch(mealPlanProvider);

    await up.loadUserData();

    if (up.recipes.isEmpty) {
      await up.computeMealPlan();
    }

    if (mp.showingNew) {
      await mp.loadMealsForIDs(up.recipes);
    } else {
      var ids = up.recipesLiked + up.recipesDisliked;
      await mp.loadMealsForIDs(ids);
    }

    ref.read(shoppingListProvider).buildUnifiedShoppingList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mealPlan = _getMealPlan();
  }

  @override
  Widget build(_) {
    return Scaffold(
      appBar: _getAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: FutureBuilder<List<Meal>>(
                  future: _mealPlan,
                  builder: (BuildContext context2,
                      AsyncSnapshot<List<Meal>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ProgressSpinner();
                    } else {
                      var mp = ref.watch(mealPlanProvider);
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (mp.all.isEmpty) {
                        if (mp.showingNew) {
                          return _loading
                              ? const ProgressSpinner()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    emptyState(context2,
                                        'Meal plan under development 👷'),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _getMealPlan();

                                        var mp = ref.read(mealPlanProvider);
                                        if (mp.all.isEmpty) {
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'Nothing available yet...'),
                                          );
                                          ScaffoldMessenger.of(context2)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: const Text('Check For Plan'),
                                    ),
                                  ],
                                );
                        } else {
                          return _loading
                              ? const ProgressSpinner()
                              : emptyState(
                                  context2, 'Time to start cooking! 🧑‍🍳');
                        }
                      } else {
                        var mp = ref.watch(mealPlanProvider);

                        return ListView.builder(
                          shrinkWrap: true,
                          restorationId:
                              'sampleItemListView', // listview to restore position
                          itemCount: mp.all.length,
                          itemBuilder: (BuildContext context3, int index) {
                            final meal = mp.all[index];

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
                                    MealCard(meal: meal),
                                    comfortBox(index),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.restorablePushNamed(
                                    context3,
                                    MealPlanDetailsView.routeName,
                                    arguments: meal.id,
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(mealPlanProvider).showingNew ? 0 : 1,
        selectedItemColor: Colors.amber[800],
        onTap: (index) async {
          var mp = ref.read(mealPlanProvider);
          var up = ref.read(userProvider);

          setState(() {
            _loading = true;
          });

          if (index == 0) {
            mp.showNewMeals(true);

            await mp.loadMealsForIDs(up.recipes);

            ref.read(shoppingListProvider).buildUnifiedShoppingList();
          } else {
            mp.showNewMeals(false);

            var ids = up.recipesLiked + up.recipesDisliked;

            await mp.loadMealsForIDs(ids.toSet().toList());
          }

          setState(() {
            _loading = false;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: 'My Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Center emptyState(BuildContext context, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }

  Widget comfortBox(int index) {
    var isEnd = index == ref.watch(mealPlanProvider).all.length - 1;
    if (isEnd) {
      return const SizedBox(height: 8);
    } else {
      return const SizedBox();
    }
  }

  AppBar _getAppBar() {
    return AppBar(
      title: ref.watch(mealPlanProvider).showingNew
          ? const Text('My Meal Plan')
          : const Text('My History'),
      leading: ref.watch(mealPlanProvider).showingNew
          ? IconButton(
              icon: const Icon(Icons.shopping_basket),
              onPressed: () {
                showModalBottomSheet<void>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context2) {
                    return const ShoppingList();
                  },
                );
              },
            )
          : const SizedBox(),
      actions: [
        IconButton(
          icon: const Icon(Icons.face),
          onPressed: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
      ],
    );
  }
}
