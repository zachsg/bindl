import 'package:bindl/controllers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeInfo extends ConsumerStatefulWidget {
  const RecipeInfo({Key? key}) : super(key: key);

  @override
  _RecipeInfoState createState() => _RecipeInfoState();
}

class _RecipeInfoState extends ConsumerState<RecipeInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(),
              Column(
                children: [
                  Text(
                    'Servings',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(10),
                    icon: const SizedBox(),
                    underline: const SizedBox(),
                    value: ref.watch(recipeProvider).servings,
                    onChanged: (servings) {
                      if (servings != null) {
                        ref.read(recipeProvider).setServings(servings);
                      }
                    },
                    items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value == 1 ? '$value person' : '$value people',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Cook Time',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(10),
                    icon: const SizedBox(),
                    underline: const SizedBox(),
                    value: ref.watch(recipeProvider).duration,
                    onChanged: (duration) {
                      if (duration != null) {
                        ref.read(recipeProvider).setDuration(duration);
                      }
                    },
                    items: <int>[
                      10,
                      15,
                      20,
                      25,
                      30,
                      35,
                      40,
                      45,
                      50,
                      55,
                      60,
                      75,
                      90
                    ].map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          '$value min',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
