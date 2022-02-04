import 'package:bodai/features/butler/bodai_butler_widget.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/features/meal_plan/plan_view.dart';
import 'package:bodai/features/my_content/views/my_recipes_view.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'butler/bodai_butler_view.dart';
import 'cookbook/cookbook_view.dart';
import 'meal_plan/meal_plan_controller.dart';

final opacityProvider = StateProvider<double>((_) => 1.0);

class BottomNavView extends ConsumerStatefulWidget {
  const BottomNavView({Key? key}) : super(key: key);

  static const routeName = '/meal_plan';

  @override
  _MealPlanView createState() => _MealPlanView();
}

class _MealPlanView extends ConsumerState<BottomNavView> {
  late Future<Meal> _meal;

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
                        _emptyState(context2, mealPlanNetworkErrorLabel),
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
                    return const FadeInWidget(
                      child: BodaiButlerView(),
                    );
                  } else if (ref.watch(bottomNavProvider) == 1) {
                    return const FadeInWidget(
                      child: CookbookView(),
                    );
                  } else if (ref.watch(bottomNavProvider) == 2) {
                    if (ref.watch(mealPlanProvider).all.isEmpty) {
                      return const MyRecipesView();
                    } else {
                      return const FadeInWidget(
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
        onTap: (index) {
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
              ref.read(consecutiveSwipesProvider.notifier).state = 0;

              ref.read(opacityProvider.state).state = 0.0;

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(opacityProvider.state).state = 1.0;
              });

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(bottomNavProvider.state).state = 1;
              });

              break;
            case 2:
              ref.read(consecutiveSwipesProvider.notifier).state = 0;

              ref.read(opacityProvider.state).state = 0.0;

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(opacityProvider.state).state = 1.0;
              });

              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(bottomNavProvider.state).state = 2;
              });

              break;
            case 3:
              ref.read(consecutiveSwipesProvider.notifier).state = 0;

              ref.read(bottomNavProvider.state).state = 3;
              break;
            default:
              ref.read(bottomNavProvider.state).state = 0;
          }
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

    final plan = BottomNavigationBarItem(
      icon: const Icon(Icons.ballot_outlined),
      label: planLabel + ' (${ref.watch(userProvider).recipes.length})',
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
