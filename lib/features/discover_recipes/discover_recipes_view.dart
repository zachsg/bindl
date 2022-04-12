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
  const DiscoverRecipesView({Key? key}) : super(key: key);

  static const routeName = '/discover_recipes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allergies = ref.watch(userProvider).allergies;
    final diets = ref.watch(userProvider).diets;
    final cuisines = ref.watch(userProvider).cuisines;
    final appliances = ref.watch(userProvider).appliances;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
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
                          'Diets I Follow',
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
                          'Cuisines I Like',
                          const CuisinesWidget(),
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
                    ),
                    icon: const Icon(Icons.filter_list),
                  ),
                ],
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
