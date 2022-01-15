import 'package:bodai/models/xmodels.dart';
import 'package:bodai/controllers/providers.dart';
import 'package:bodai/screens/meal_plan/plan_view.dart';
import 'package:bodai/screens/my_content/my_recipes_view.dart';
import 'package:bodai/screens/settings/settings_view.dart';
import 'package:bodai/utils/strings.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meal_history_view.dart';
import 'bodai_butler_view.dart';
import 'shopping_list_widget.dart';

class MealPlanView extends ConsumerStatefulWidget {
  const MealPlanView({Key? key}) : super(key: key);

  static const routeName = '/meal_plan';

  @override
  _MealPlanView createState() => _MealPlanView();
}

class _MealPlanView extends ConsumerState<MealPlanView> {
  late Future<Meal> _meal;
  bool _loading = false;

  Future<Meal> _getMeal() async {
    await ref.read(mealsProvider.notifier).load();

    return ref.watch(bestMealProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _meal = _getMeal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Meal>(
              future: _meal,
              builder: (BuildContext context2, AsyncSnapshot<Meal> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProgressSpinner();
                } else {
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _emptyState(context2, mealPlanNetworkErrorLable),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _meal = _getMeal();
                            });
                          },
                          child: const Text(tryAgainLabel),
                        ),
                      ],
                    );
                  } else if (ref.watch(bottomNavProvider) == 0) {
                    if (ref.watch(bestMealProvider).id == -1) {
                      return _emptyState(context,
                          'Bodai Butler couldn\'t find any new matching your palate found today 😴');
                    } else {
                      return _loading
                          ? const ProgressSpinner()
                          : const FadeInWidget(
                              child: BodaiButlerView(),
                            );
                    }
                  } else if (ref.watch(bottomNavProvider) == 1) {
                    return _loading
                        ? const ProgressSpinner()
                        : const FadeInWidget(
                            child: MealHistoryView(),
                          );
                  } else if (ref.watch(bottomNavProvider) == 2) {
                    if (ref.watch(mealPlanProvider).all.isEmpty) {
                      return const MyRecipesView();
                    } else {
                      return _loading
                          ? const ProgressSpinner()
                          : const FadeInWidget(
                              child: PlanView(),
                            );
                    }
                  } else {
                    return const MyRecipesView();
                  }
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(bottomNavProvider),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedFontSize: 12.0,
        onTap: (index) async {
          setState(() {
            _loading = true;
          });

          switch (index) {
            case 0:
              ref.read(opacityProvider.state).state = 0.0;

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(opacityProvider.state).state = 1.0;
              });

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(bottomNavProvider.state).state = 0;
              });

              ref.read(mealsProvider.notifier).load();

              break;
            case 1:
              ref.read(opacityProvider.state).state = 0.0;

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(opacityProvider.state).state = 1.0;
              });

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(bottomNavProvider.state).state = 1;
              });

              break;
            case 2:
              ref.read(opacityProvider.state).state = 0.0;

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(opacityProvider.state).state = 1.0;
              });

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(bottomNavProvider.state).state = 2;
              });

              break;
            case 3:
              ref.read(bottomNavProvider.state).state = 3;
              break;
            default:
              ref.read(bottomNavProvider.state).state = 0;
          }

          setState(() {
            _loading = false;
          });
        },
        items: _bottomNavItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> _bottomNavItems() {
    List<BottomNavigationBarItem> items = [];

    const butler = BottomNavigationBarItem(
      icon: Icon(Icons.room_service_outlined),
      label: mealPlanLabel,
    );

    const cookbook = BottomNavigationBarItem(
      icon: Icon(Icons.menu_book_outlined),
      label: cookbookLabel,
    );

    const plan = BottomNavigationBarItem(
      icon: Icon(Icons.ballot_outlined),
      label: planLabel,
    );

    const creations = BottomNavigationBarItem(
      icon: Icon(Icons.brush_outlined),
      label: creationsLabel,
    );

    items.add(butler);
    items.add(cookbook);

    if (ref.watch(userProvider).recipes.isNotEmpty) {
      items.add(plan);
    }

    items.add(creations);

    return items;
  }

  Center _emptyState(BuildContext context, String text) {
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
}
