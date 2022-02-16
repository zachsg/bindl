import 'package:bodai/features/butler/bodai_butler_widget.dart';
import 'package:bodai/features/cookbook/widgets/cookbook_item_widget.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:bodai/features/settings/settings_view.dart';
import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/cookbook_controller.dart';
import 'controllers/ingredients_search_controller.dart';
import 'widgets/ingredient_filter_widget.dart';

class CookbookView extends ConsumerWidget {
  const CookbookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$myLabel $cookbookLabel'),
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
        child: ref.watch(userProvider).recipesLiked.isEmpty
            ? _emptyState(context, ref)
            : _mealCardList(context, ref),
      ),
    );
  }

  Column _emptyState(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Start by adding meals to your cookbook!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            ref.read(bottomNavProvider.notifier).state = 0;
          },
          child: const Text('Take Me To My Butler'),
        )
      ],
    );
  }

  Widget _mealCardList(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      restorationId: 'sampleItemListView', // listview to restore position
      itemCount: ref.watch(cookbookProvider).length + 1,
      itemBuilder: (BuildContext context2, int index) {
        if (index == 0 && ref.watch(cookbookProvider).isEmpty) {
          return Column(
            children: [
              const IngredientFilterWidget(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _manageEmptyState(context2, ref),
              ),
            ],
          );
        } else if (index == 0) {
          return const IngredientFilterWidget();
        } else {
          final meal = ref.watch(cookbookProvider)[index - 1];

          return CookbookItemWidget(meal: meal);
        }
      },
    );
  }

  Widget _manageEmptyState(BuildContext context, WidgetRef ref) {
    if (ref.watch(ingredientsSearchProvider).isNotEmpty) {
      if (ref.watch(bestMealProvider).id == -1) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
          child: Text(
            'Your Butler searched high and low but couldn\'t find the '
            'right meal. He\'s reported his failure to HQ.',
            style: Theme.of(context).textTheme.headline2,
          ),
        );
      } else {
        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
              child: Text(
                'No matches found in your cookbook.\nBut... your Butler '
                'searched the globe, and found this meal to be your best '
                'match. How\'d the butler do?',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).disabledColor),
              ),
            ),
            BodaiButlerWidget(parentRef: ref),
          ],
        );
      }
    } else if (ref.watch(cookbookProvider).isEmpty &&
        ref.watch(ingredientsSearchProvider).isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Start by adding meals to your cookbook!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavProvider.notifier).state = 0;
            },
            child: const Text('Take Me To My Butler'),
          )
        ],
      );
    } else {
      return Text(
        'No meals found in your cookbook containing all of those ingredients',
        style: Theme.of(context).textTheme.headline2,
      );
    }
  }
}
