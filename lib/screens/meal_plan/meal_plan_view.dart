import 'package:bindl/meal_plan/meal_plan_current_view.dart';
import 'package:bindl/models/models.dart';
import 'package:bindl/settings/settings_view.dart';
import 'package:bindl/controllers/controllers.dart';
import 'package:bindl/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                      var up = ref.watch(userProvider);
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
                                    up.recipesLiked.isNotEmpty
                                        ? emptyState(context2,
                                            'You completed your plan. Time for another! 👷')
                                        : emptyState(context2,
                                            'Meal plan under development 👷'),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _getMealPlan();

                                        var mp = ref.read(mealPlanProvider);
                                        if (mp.all.isEmpty) {
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'Working on it! Check back soon...'),
                                          );
                                          ScaffoldMessenger.of(context2)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: const Text('GET NEW PLAN'),
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
                        return const MealPlanCurrentView();
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
          } else if (index == 1) {
            mp.showNewMeals(false);
            var ids = up.recipesLiked + up.recipesDisliked;
            await mp.loadMealsForIDs(ids.toSet().toList());
          } else {
            // Currently a 3rd option does not exist
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
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
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
