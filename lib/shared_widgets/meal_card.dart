import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isMealLoadingProvider = StateProvider<bool>((_) => false);

class MealCard extends ConsumerWidget {
  const MealCard({
    Key? key,
    required this.meal,
    this.isMyRecipe = false,
  }) : super(key: key);

  final Meal meal;
  final bool isMyRecipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          cardCover(context, ref, meal),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _cardFooter(context, meal, ref),
                  isMyRecipe
                      ? CreatorFooterWidget(mealID: meal.id)
                      : const SizedBox(),
                ],
              ),
              isMyRecipe
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextButton.icon(
                        label: Text(
                          meal.comments.length.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.70,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            context: context,
                            builder: (BuildContext context2) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          globalDiscussionLabel,
                                          style: Theme.of(context2)
                                              .textTheme
                                              .headline6,
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.cancel),
                                          onPressed: () =>
                                              Navigator.pop(context2),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: DiscussionWidget(meal: meal),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.insert_comment,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Container cardCover(BuildContext context, WidgetRef ref, Meal meal) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                meal.imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).shadowColor.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    meal.name,
                    style: Theme.of(context).textTheme.headline2,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      constraints: const BoxConstraints.expand(
        width: 400,
        height: 300,
      ),
    );
  }

  Padding _cardFooter(BuildContext context, Meal meal, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 4),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
              ),
              Text(
                '${meal.duration} $minLabel',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              const Icon(
                Icons.kitchen_outlined,
              ),
              Text(
                '${meal.ingredients.length} ${ingredientsLabel.toLowerCase()}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
