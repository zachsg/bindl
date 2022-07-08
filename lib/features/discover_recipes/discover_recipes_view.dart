import 'package:bodai/features/discover_recipes/discover_recipes_controller.dart';
import 'package:bodai/features/discover_recipes/widgets/search_recipes_widget.dart';
import 'package:bodai/providers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/allergies_widget.dart';
import 'widgets/appliances_widget.dart';
import 'widgets/cuisines_widget.dart';
import 'widgets/diets_widget.dart';
import 'widgets/discover_recipes_list_widget.dart';
import 'widgets/filter_recipes_widget.dart';
import 'widgets/preference_card_widget.dart';

class DiscoverRecipesView extends ConsumerWidget {
  const DiscoverRecipesView({super.key});

  static const routeName = '/discover_recipes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allergies = ref.watch(userProvider).allergies;
    final diets = ref.watch(userProvider).diets;
    final cuisines = ref.watch(userProvider).cuisines;
    final appliances = ref.watch(userProvider).appliances;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
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
                          'I\'m Allergic To',
                          const PreferenceCardWidget(
                            title: 'Allergies',
                            widget: AllergiesWidget(),
                          ),
                          ref,
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
                          'Diets I Will Eat',
                          const DietsWidget(),
                          ref,
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
                          'Cuisines I Like',
                          const CuisinesWidget(),
                          ref,
                        ),
                        icon: const Icon(Icons.restaurant_menu),
                      ),
                      cuisines.isNotEmpty
                          ? Text(cuisines.length.toString())
                          : const SizedBox(),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _showMyDialog(
                          context,
                          'Appliances I Have',
                          const AppliancesWidget(),
                          ref,
                        ),
                        icon: const Icon(Icons.blender),
                      ),
                      appliances.isNotEmpty
                          ? Text(appliances.length.toString())
                          : const SizedBox(),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _showMyDialog(
                      context,
                      'Filter Recipes By',
                      const FilterRecipesWidget(),
                      ref,
                    ),
                    icon: const Icon(Icons.filter_list),
                  ),
                ],
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 10.0,
              //     right: 10.0,
              //     top: 8.0,
              //   ),
              //   child: ExpansionPanelList(
              //     children: [
              //       ExpansionPanel(
              //         headerBuilder: (context, isExpanded) {
              //           return const Padding(
              //             padding: EdgeInsets.only(top: 8.0, left: 8.0),
              //             child: Text(
              //                 'You have ingredients that are expiring soon! Filter recipes by them.'),
              //           );
              //         },
              //         body: Wrap(
              //           spacing: 8,
              //           children: [
              //             FilterChip(
              //               label: Text('Spinach'),
              //               selected: true,
              //               onSelected: (selected) {},
              //             ),
              //             FilterChip(
              //               label: Text('Cucumber'),
              //               onSelected: (selected) {},
              //             ),
              //           ],
              //         ),
              //         isExpanded:
              //             ref.watch(ingredientsExpiringSoonExpandedProvider),
              //       ),
              //     ],
              //     expansionCallback: (i, isExpanded) {
              //       ref
              //           .read(ingredientsExpiringSoonExpandedProvider.notifier)
              //           .state = !isExpanded;
              //     },
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 8,
                  bottom: 4,
                ),
                child: SearchRecipesWidget(),
              ),
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
      BuildContext context, String title, Widget widget, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: widget),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () async {
                final navigator = Navigator.of(context);

                await ref.read(discoverRecipesProvider.notifier).load();

                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
