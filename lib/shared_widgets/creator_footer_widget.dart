import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/my_content/controllers/recipe_stats_controller.dart';
import '../utils/strings.dart';

class CreatorFooterWidget extends ConsumerWidget {
  const CreatorFooterWidget({Key? key, required this.mealID}) : super(key: key);

  final int mealID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rp = ref.watch(recipeStatsProvider)[mealID];

    return Padding(
      padding: const EdgeInsets.only(top: 2.0, left: 0.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.menu_book,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                ' In ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                rp?.inNumCookbooks == 1
                    ? '${rp?.inNumCookbooks ?? 0} cookbook'
                    : '${rp?.inNumCookbooks ?? 0} cookbooks',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                ' $cookedXTimesLabel ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                rp?.numLikes == 1
                    ? '${rp?.numLikes ?? 0} time'
                    : '${rp?.numLikes ?? 0} times',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.ballot_outlined,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                ' $currentlyInLabel ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                rp?.inNumOfPlans == 1
                    ? '${rp?.inNumOfPlans ?? 0} meal plan'
                    : '${rp?.inNumOfPlans ?? 0} meal plans',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
