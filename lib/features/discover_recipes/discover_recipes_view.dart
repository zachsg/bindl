import 'package:bodai/providers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/allergies_widget.dart';
import 'widgets/cuisines_widget.dart';
import 'widgets/diets_widget.dart';
import 'widgets/discover_recipes_list_widget.dart';
import 'widgets/filter_recipes_widget.dart';
import 'widgets/preference_card_widget.dart';

class DiscoverRecipesView extends ConsumerWidget {
  const DiscoverRecipesView({Key? key}) : super(key: key);

  static const routeName = '/discover_recipes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allergies = ref.watch(userProvider).allergies;
    var diets = ref.watch(userProvider).diets;
    var cuisines = ref.watch(userProvider).cuisines;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _showMyDialog(
                          context,
                          'Set Your Allergies',
                          const PreferenceCardWidget(
                            title: 'Allergies',
                            widget: AllergiesWidget(),
                          ),
                        ),
                        icon: const Icon(Icons.grass),
                      ),
                      allergies.isNotEmpty
                          ? Text(allergies.length.toString())
                          : const SizedBox(),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _showMyDialog(
                          context,
                          'Filter By Diet',
                          const DietsWidget(),
                        ),
                        icon: const Icon(Icons.monitor_weight),
                      ),
                      diets.isNotEmpty
                          ? Text(diets.length.toString())
                          : const SizedBox(),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _showMyDialog(
                          context,
                          'Filter By Cuisines',
                          const CuisinesWidget(),
                        ),
                        icon: const Icon(Icons.restaurant_menu),
                      ),
                      cuisines.isNotEmpty
                          ? Text(cuisines.length.toString())
                          : const SizedBox(),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _showMyDialog(
                      context,
                      'Filter Recipes By',
                      const FilterRecipesWidget(),
                    ),
                    icon: const Icon(Icons.book),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     const Expanded(
              //       child: SearchIngredientsWidget(),
              //     ),
              //     IconButton(
              //       onPressed: () => _showMyDialog(
              //         context,
              //         'Sort Recipes By',
              //         Text('hi'),
              //       ),
              //       icon: const Icon(Icons.sort),
              //     ),
              //   ],
              // ),
              const Expanded(
                child: DiscoverRecipesListWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, String title, Widget widget) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: widget),
          actions: <Widget>[
            TextButton(
              child: const Text('Done!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
