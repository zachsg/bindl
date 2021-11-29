import 'package:bindl/settings/settings_view.dart';
import 'package:bindl/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meal.dart';
import 'meal_plan_details_view.dart';

class MealPlanView extends ConsumerStatefulWidget {
  const MealPlanView({Key? key}) : super(key: key);

  static const routeName = '/meal_plan';

  @override
  _MealPlanViewState createState() => _MealPlanViewState();
}

class _MealPlanViewState extends ConsumerState<MealPlanView> {
  Future<List<Meal>> getMealPlan() async {
    var mp = ref.read(mealPlanProvider);
    var uc = ref.read(userProvider);
    await uc.loadUserData();
    await mp.loadMealsForIDs(uc.recipes());

    return mp.all();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
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
        future: getMealPlan(),
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
              var mp = ref.read(mealPlanProvider);
              return ListView.builder(
                restorationId:
                    'sampleItemListView', // listview to restore position
                itemCount: mp.all().length,
                itemBuilder: (BuildContext context, int index) {
                  final meal = mp.all()[index];

                  return ListTile(
                      title: Text(meal.name),
                      leading: const CircleAvatar(
                        foregroundImage:
                            AssetImage('assets/images/flutter_logo.png'),
                      ),
                      onTap: () {
                        Navigator.restorablePushNamed(
                          context,
                          MealPlanDetailsView.routeName,
                          arguments: meal.toJson(),
                        );
                      });
                },
              );
            }
          }
        },
      ),
    );
  }
}
