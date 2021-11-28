import 'package:bindl/shared/providers.dart';
import 'package:bindl/survey/survey_meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyStack extends ConsumerWidget {
  const SurveyStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mealProvider = ref.watch(surveyProvider);

    return Stack(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              child: SurveyMealCard(meal: mealProvider.allMeals[index]),
              key: ValueKey<String>(mealProvider.allMeals[index].name),
              background: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3.5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.thumb_up),
                    Spacer(),
                  ],
                ),
              ),
              secondaryBackground: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3.5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Spacer(),
                    Icon(Icons.thumb_down),
                  ],
                ),
              ),
              onDismissed: (DismissDirection direction) {
                bool isLike = direction == DismissDirection.startToEnd;

                final mp = ref.read(surveyProvider);
                ref.read(userProvider).addTags(mp.allMeals[index].tags, isLike);

                mp.removeMealAtIndex(index);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 20);
          },
          itemCount: mealProvider.allMeals.length,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 1.8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  final mp = ref.read(surveyProvider);

                  if (mp.allMeals.isNotEmpty) {
                    ref.read(userProvider).addTags(mp.allMeals[0].tags, false);
                    mp.removeMealAtIndex(0);
                  }
                },
                child: const Icon(Icons.thumb_down),
              ),
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  final mp = ref.read(surveyProvider);
                  if (mp.allMeals.isNotEmpty) {
                    ref.read(userProvider).addTags(mp.allMeals[0].tags, true);
                    mp.removeMealAtIndex(0);
                  }
                },
                child: const Icon(Icons.thumb_up),
              ),
              const Spacer(),
            ],
          ),
        ),
        // TODO: Remove this widget, testing only
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 1.4,
          ),
          child: Text(formatLikesDislikes(ref)),
        ),
      ],
    );
  }

  // TODO: Remove this helper method, testing only
  String formatLikesDislikes(WidgetRef ref) {
    final uc = ref.watch(userProvider);

    var likes = '';
    var dislikes = '';
    var sorted = uc.sortedTags();

    for (var entry in sorted) {
      if (entry.value > 0) {
        likes += '(${entry.key}:${entry.value}), ';
      } else if (entry.value < 0) {
        dislikes += '(${entry.key}:${entry.value}), ';
      }
    }

    return 'Liked: ${likes.replaceAll('Tag.', '')}'
        '\nDisliked: ${dislikes.replaceAll('Tag.', '')}';
  }
}

class SurveyMealCard extends StatelessWidget {
  const SurveyMealCard({Key? key, required this.meal}) : super(key: key);

  final SurveyMeal meal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: Column(
        children: [
          Card(
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints.expand(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.91,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(meal.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Text(
                    meal.name,
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
