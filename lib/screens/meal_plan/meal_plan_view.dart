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

  Future<void> _refresh() async {
    await ref.read(mealsProvider.notifier).load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _meal = _getMeal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: SafeArea(
        child: Column(
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
      label: historyLabel,
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

  SingleChildScrollView _readyForNewMealPlan() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Text(
                newPlanHelperLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 16),
            const AdoreIngredientsCard(shouldPersist: false),
            const SizedBox(height: 16),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });

                    await ref.read(userProvider).save();
                    await _getMeal();

                    setState(() {
                      _loading = false;
                    });
                  },
                  child: Text(
                    newPlanButtonLabel,
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
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

  Widget _getAppBarTitle() {
    var bp = ref.watch(bottomNavProvider);

    if (bp == 0) {
      return const Text('$mealPlanLabel $forMeLabel');
    } else if (bp == 1) {
      return const Text('$myLabel $historyLabel');
    } else {
      return const Text('$myLabel $creationsLabel');
    }
  }

  AppBar _getAppBar() {
    Widget leadingIcon = const SizedBox();
    if (ref.watch(bottomNavProvider) == 0) {
      leadingIcon = IconButton(
        icon: const Icon(Icons.lightbulb_outline),
        tooltip: educationLabel,
        onPressed: () async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(educationHeaderLabel),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        educationBodyOneLabel,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        educationBodyTwoLabel,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(educationButtonLabel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else if (ref.watch(bottomNavProvider) == 2) {
      leadingIcon = IconButton(
        icon: const Icon(Icons.shopping_basket),
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.90),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (BuildContext context2) {
              return const ShoppingListWidget();
            },
          );
        },
      );
    }

    return AppBar(
      title: _getAppBarTitle(),
      leading: leadingIcon,
      actions: [
        IconButton(
          icon: const Icon(Icons.face),
          tooltip: preferencesLabel,
          onPressed: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
      ],
    );
  }
}
