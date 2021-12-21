import 'package:bindl/meal_plan/ingredient.dart';
import 'package:bindl/settings/settings_view.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/utils/helper.dart';
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

    Helper.buildUnifiedShoppingList(ref);

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

    Helper.buildUnifiedShoppingList(ref);
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
                      return progressIndicator();
                    } else {
                      var mp = ref.watch(mealPlanProvider);
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (mp.all.isEmpty) {
                        if (mp.showingNew) {
                          return _loading
                              ? progressIndicator()
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
                              ? progressIndicator()
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
                                    Card(
                                      elevation: 2,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          cardCover(context3, meal),
                                          cardFooter(context3, meal),
                                        ],
                                      ),
                                    ),
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

            Helper.buildUnifiedShoppingList(ref);
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

  Padding progressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(64.0),
      child: Center(
        child: CircularProgressIndicator(),
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

  Container cardCover(BuildContext context, Meal meal) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: _loading
                  ? progressIndicator()
                  : Image.network(
                      meal.imageURL,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).shadowColor.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    meal.name,
                    style: Theme.of(context).textTheme.headline2,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      constraints: const BoxConstraints.expand(
        width: 350,
        height: 300,
      ),
    );
  }

  Padding cardFooter(BuildContext context, Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 4),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
              ),
              Text(
                '${meal.duration} min',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              const Icon(
                Icons.kitchen_outlined,
              ),
              Text(
                '${meal.ingredients.length} ingredients',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Row(children: [
            getIconRatingForMeal(meal),
          ]),
        ],
      ),
    );
  }

  Widget getIconRatingForMeal(Meal meal) {
    var liked = ref.watch(userProvider).recipesLiked;
    var disliked = ref.watch(userProvider).recipesDisliked;

    if (liked.contains(meal.id)) {
      var likes = liked.where((id) => id == meal.id);

      return Row(
        children: [
          Icon(
            Icons.thumb_up_outlined,
            color: Theme.of(context).dividerColor,
          ),
          Text(
            'x${likes.length}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      );
    } else if (disliked.contains(meal.id)) {
      return Icon(
        Icons.thumb_down_outlined,
        color: Theme.of(context).dividerColor,
      );
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        shoppingListHeader(context2),
                        shoppingListBody(),
                      ],
                    );
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

  Expanded shoppingListBody() {
    var mp = ref.watch(mealPlanProvider);
    var sp = ref.watch(shoppingListProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: sp.all.length,
          itemBuilder: (context, index) {
            var ingredient = sp.all[index];

            var measurementFormatted =
                ingredient.measurement.name.replaceAll('item', '').trim();

            var isItem = ingredient.measurement.name.contains('item');

            var quantityWithServings =
                ingredient.quantity * ref.watch(userProvider).servings;

            var quantity = isInteger(quantityWithServings)
                ? quantityWithServings.ceil()
                : double.parse(quantityWithServings.toStringAsFixed(2))
                    .toFractionString();

            return Row(
              children: [
                Text(
                  ingredient.name.split(',').first.capitalize(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  ' ($quantity',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  isItem ? '$measurementFormatted)' : ' $measurementFormatted)',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding shoppingListHeader(BuildContext context2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Shopping List',
            style: Theme.of(context2).textTheme.headline6,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.pop(context2),
          ),
        ],
      ),
    );
  }
}
