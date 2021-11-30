import 'package:bindl/meal_plan/ingredient.dart';
import 'package:bindl/settings/settings_view.dart';
import 'package:bindl/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meal.dart';
import 'meal_plan_details_view.dart';

class MealPlanView extends ConsumerWidget {
  const MealPlanView({Key? key}) : super(key: key);

  static const routeName = '/meal_plan';

  Future<List<Meal>> getMealPlan(WidgetRef ref) async {
    var mp = ref.read(mealPlanProvider);
    var uc = ref.read(userProvider);
    await uc.loadUserData();
    await mp.loadMealsForIDs(uc.recipes());

    return mp.all();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        leading: IconButton(
          icon: const Icon(Icons.shopping_basket),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                var shoppingList = <Ingredient>[];
                for (var meal in ref.read(mealPlanProvider).all()) {
                  for (var ingredient in meal.ingredients) {
                    shoppingList.add(ingredient);
                  }
                }
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
                            style: Theme.of(context).textTheme.headline6,
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
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: shoppingList.length,
                          itemBuilder: (context, index) {
                            var ingredient = shoppingList[index];
                            var measurementFormatted = ingredient.measurement
                                .toString()
                                .replaceAll('Measurement.', '');

                            return Row(
                              children: [
                                Text(
                                  ingredient.name,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(' (${ingredient.quantity}'),
                                Text(' $measurementFormatted)'),
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
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.face),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Meal>>(
        future: getMealPlan(ref),
        builder: (BuildContext context, AsyncSnapshot<List<Meal>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              var mp = ref.watch(mealPlanProvider);
              return ListView.builder(
                restorationId:
                    'sampleItemListView', // listview to restore position
                itemCount: mp.all().length,
                itemBuilder: (BuildContext context, int index) {
                  final meal = mp.all()[index];

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      child: Container(
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 8,
                              left: -2,
                              child: Text(
                                ' ${meal.name} ',
                                style: Theme.of(context).textTheme.overline,
                              ),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints.expand(
                          width: 350,
                          height: 300,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(meal.imageURL),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      onTap: () {
                        Navigator.restorablePushNamed(
                          context,
                          MealPlanDetailsView.routeName,
                          arguments: meal.toJson(),
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
    );
  }
}
