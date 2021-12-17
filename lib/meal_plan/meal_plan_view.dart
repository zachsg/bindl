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
  Future<List<Meal>> _getMealPlan() async {
    await ref.read(userProvider).loadUserData();

    if (ref.read(userProvider).recipes().isEmpty) {
      await ref.read(userProvider).computeMealPlan();
    }

    if (ref.read(mealPlanProvider).showingNew()) {
      await ref
          .read(mealPlanProvider)
          .loadMealsForIDs(ref.read(userProvider).recipes());
    } else {
      var ids = ref.read(userProvider).recipesLiked() +
          ref.read(userProvider).recipesDisliked();
      await ref.read(mealPlanProvider).loadMealsForIDs(ids);
    }

    _buildUnifiedShoppingList();

    return ref.watch(mealPlanProvider).all();
  }

  void _buildUnifiedShoppingList() {
    var shoppingList = <Ingredient>[];
    for (var meal in ref.read(mealPlanProvider).all()) {
      for (var ingredient in meal.ingredients) {
        var singleServingIngredient = Ingredient(
            name: ingredient.name,
            quantity: ingredient.quantity / meal.servings,
            measurement: ingredient.measurement);

        shoppingList.add(singleServingIngredient);
      }
    }

    ref.read(mealPlanProvider).buildUnifiedShoppingList(shoppingList);
  }

  Future<void> _refresh() async {
    await ref.read(userProvider).loadUserData();

    if (ref.read(userProvider).recipes().isEmpty) {
      await ref.read(userProvider).computeMealPlan();
    }

    if (ref.read(mealPlanProvider).showingNew()) {
      await ref
          .read(mealPlanProvider)
          .loadMealsForIDs(ref.read(userProvider).recipes());
    } else {
      var ids = ref.read(userProvider).recipesLiked() +
          ref.read(userProvider).recipesDisliked();
      await ref.read(mealPlanProvider).loadMealsForIDs(ids);
    }

    _buildUnifiedShoppingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: FutureBuilder<List<Meal>>(
                  future: _getMealPlan(),
                  builder: (BuildContext context3,
                      AsyncSnapshot<List<Meal>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(64.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (ref.watch(mealPlanProvider).all().isEmpty) {
                        if (ref.read(mealPlanProvider).showingNew()) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Meal plan under development 👷',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Time to start cooking! 🧑‍🍳',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          );
                        }
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          restorationId:
                              'sampleItemListView', // listview to restore position
                          itemCount: ref.watch(mealPlanProvider).all().length,
                          itemBuilder: (BuildContext context4, int index) {
                            final meal =
                                ref.read(mealPlanProvider).all()[index];

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
                                          Container(
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                    child: Image.network(
                                                      meal.imageURL,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 0,
                                                  bottom: 0,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: Theme.of(context)
                                                        .shadowColor
                                                        .withOpacity(0.6),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Text(
                                                          meal.name,
                                                          style:
                                                              Theme.of(context4)
                                                                  .textTheme
                                                                  .headline2,
                                                          maxLines: 3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            constraints:
                                                const BoxConstraints.expand(
                                              width: 350,
                                              height: 300,
                                            ),
                                          ),
                                          cardFooter(context, meal, context4),
                                        ],
                                      ),
                                    ),
                                    index ==
                                            ref
                                                    .watch(mealPlanProvider)
                                                    .all()
                                                    .length -
                                                1
                                        ? const SizedBox(height: 8)
                                        : const SizedBox(),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.restorablePushNamed(
                                    context4,
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
        currentIndex: ref.read(mealPlanProvider).showingNew() ? 0 : 1,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if (index == 0) {
            ref.read(mealPlanProvider).showNewMeals(true);
          } else {
            ref.read(mealPlanProvider).showNewMeals(false);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: 'My Plan',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: 'History'),
        ],
      ),
    );
  }

  Padding cardFooter(BuildContext context, Meal meal, BuildContext context4) {
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
    var liked = ref.read(userProvider).recipesLiked();
    var disliked = ref.read(userProvider).recipesDisliked();

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
      title: ref.read(mealPlanProvider).showingNew()
          ? const Text('My Meal Plan')
          : const Text('My History'),
      leading: ref.read(mealPlanProvider).showingNew()
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
                        Padding(
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
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ListView.builder(
                              itemCount: ref
                                  .watch(mealPlanProvider)
                                  .unifiedShoppingList()
                                  .length,
                              itemBuilder: (context, index) {
                                var ingredient = ref
                                    .watch(mealPlanProvider)
                                    .unifiedShoppingList()[index];
                                var measurementFormatted = ingredient
                                    .measurement.name
                                    .replaceAll('item', '')
                                    .trim();

                                var isItem = ingredient.measurement.name
                                    .contains('item');

                                var quantityWithServings = ingredient.quantity *
                                    ref.read(userProvider).servings();

                                var quantity = isInteger(quantityWithServings)
                                    ? quantityWithServings.ceil()
                                    : double.parse(quantityWithServings
                                            .toStringAsFixed(2))
                                        .toFractionString();

                                return Row(
                                  children: [
                                    Text(
                                      ingredient.name
                                          .split(',')
                                          .first
                                          .capitalize(),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      ' ($quantity',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    Text(
                                      isItem
                                          ? '$measurementFormatted)'
                                          : ' $measurementFormatted)',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
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
}
