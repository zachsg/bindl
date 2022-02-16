import 'package:bodai/features/meal_plan/models/plan_item.dart';
import 'package:bodai/features/meal_plan/widgets/plan_item_widget.dart';
import 'package:bodai/features/settings/settings_view.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/meal_plan_controller.dart';
import '../controllers/pantry_controller.dart';
import '../widgets/shopping_list_widget.dart';
import '../widgets/tutorial_card_widget.dart';

final firstToLastSortedPlanProvider = StateProvider<List<PlanItem>>((ref) {
  var list = ref.watch(mealPlanProvider);

  list.sort(((a, b) {
    if (DateTime.parse(a.plannedFor).isBefore(DateTime.parse(b.plannedFor))) {
      return 0;
    } else {
      return 1;
    }
  }));

  return list;
});

class PlanView extends ConsumerStatefulWidget {
  const PlanView({Key? key}) : super(key: key);

  @override
  _PlanViewState createState() => _PlanViewState();
}

class _PlanViewState extends ConsumerState<PlanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
        ),
        title: const Text('$myLabel Meal $planLabel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.face),
            tooltip: preferencesLabel,
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const TutorialCardWidget(),
            ref.watch(mealPlanProvider).isEmpty
                ? const SizedBox()
                : Expanded(
                    child: _mealCardList(ref),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _mealCardList(WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      restorationId: 'sampleItemListView', // listview to restore position
      itemCount: ref.watch(firstToLastSortedPlanProvider).length,
      itemBuilder: (BuildContext context3, int index) {
        final planItem = ref.watch(firstToLastSortedPlanProvider)[index];

        return Dismissible(
          key: Key(planItem.mealID.toString()),
          background: Row(
            children: const [
              Spacer(),
              Icon(Icons.cancel),
              SizedBox(width: 8),
            ],
          ),
          onDismissed: (direction) async {
            var message = 'removed from your plan';

            var meal =
                ref.read(mealsProvider.notifier).mealForID(planItem.mealID);

            ref.read(mealPlanProvider.notifier).removeFromMealPlan(meal);

            final snackBar = SnackBar(
              content: Text('${meal.name} $message'),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            if (ref.read(mealPlanProvider).isEmpty) {
              ref.read(pantryProvider).clear();
              ref.read(bottomNavProvider.notifier).state = 1;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                index == 0 ? const SizedBox(height: 2) : const SizedBox(),
                PlanItemWidget(index: index),
                _comfortBox(index, ref),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _comfortBox(int index, WidgetRef ref) {
    var isEnd = index == ref.watch(mealPlanProvider).length - 1;

    if (isEnd) {
      return const SizedBox(height: 16);
    } else {
      return const SizedBox();
    }
  }
}
