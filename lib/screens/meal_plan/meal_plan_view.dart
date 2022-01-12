import 'package:bodai/models/xmodels.dart';
import 'package:bodai/controllers/providers.dart';
import 'package:bodai/screens/my_content/my_recipes_view.dart';
import 'package:bodai/screens/settings/settings_view.dart';
import 'package:bodai/utils/strings.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meal_history_view.dart';
import 'meal_plan_current_view.dart';
import 'shopping_list_widget.dart';

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
    var up = ref.read(userProvider);

    await ref.read(mealsProvider.notifier).load();
    await up.load();

    ref.read(mealPlanProvider).load();
    ref.read(mealHistoryProvider.notifier).load();

    ref.read(shoppingListProvider).buildUnifiedShoppingList(ref);

    return ref.watch(mealPlanProvider).all;
  }

  Future<void> _refresh() async {
    var up = ref.watch(userProvider);

    await ref.read(mealsProvider.notifier).load();
    await up.load();

    ref.read(mealPlanProvider).load();
    ref.read(mealHistoryProvider.notifier).load();

    ref.read(shoppingListProvider).buildUnifiedShoppingList(ref);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mealPlan = _getMealPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Meal>>(
                future: _mealPlan,
                builder: (BuildContext context2,
                    AsyncSnapshot<List<Meal>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ProgressSpinner();
                  } else {
                    if (snapshot.hasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _emptyState(context2, mealPlanNetworkErrorLable),
                          ElevatedButton(
                            onPressed: () async {
                              await _refresh();
                            },
                            child: const Text(tryAgainLabel),
                          ),
                        ],
                      );
                    } else if (ref.watch(bottomNavProvider) == 0) {
                      if (ref.watch(mealPlanProvider).all.isEmpty) {
                        return _loading
                            ? const ProgressSpinner()
                            : _readyForNewMealPlan();
                      } else {
                        return _loading
                            ? const ProgressSpinner()
                            : const FadeInWidget(
                                child: MealPlanCurrentView(),
                              );
                      }
                    } else if (ref.watch(bottomNavProvider) == 1) {
                      if (ref.watch(mealHistoryProvider).isEmpty) {
                        return _loading
                            ? const ProgressSpinner()
                            : _emptyState(context2, mealPlanHistoryEmptyLabel);
                      } else {
                        return _loading
                            ? const ProgressSpinner()
                            : const FadeInWidget(
                                child: MealHistoryView(),
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
        unselectedFontSize: 0.0,
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
              ref.read(bottomNavProvider.state).state = 2;

              break;
            default:
              ref.read(bottomNavProvider.state).state = 0;
          }

          setState(() {
            _loading = false;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: mealPlanLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: historyLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: creationsLabel,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.kitchen_outlined),
          //   label: 'Pantry',
          // ),
        ],
      ),
    );
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
                    await _getMealPlan();

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
      return const Text('$myLabel $mealPlanLabel');
    } else if (bp == 1) {
      return const Text('$myLabel $historyLabel');
    } else {
      return const Text('$myLabel $creationsLabel');
    }
  }

  AppBar _getAppBar() {
    return AppBar(
      title: _getAppBarTitle(),
      leading: ref.watch(bottomNavProvider) == 0
          ? IconButton(
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
            )
          : const SizedBox(),
      actions: [
        ref.watch(bottomNavProvider) == 0
            ? IconButton(
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
              )
            : const SizedBox(),
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
