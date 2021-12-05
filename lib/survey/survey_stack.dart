import 'package:bindl/shared/providers.dart';
import 'package:bindl/survey/survey_meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyStack extends ConsumerWidget {
  const SurveyStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var surveyMealProvider = ref.watch(surveyProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(width: 32),
                  Icon(
                    Icons.undo,
                    size: 36,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Nay',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    'Yay',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.redo,
                    size: 36,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                  const SizedBox(width: 32),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                child: SurveyMealCard(meal: surveyMealProvider.allMeals[index]),
                key: ValueKey<String>(surveyMealProvider.allMeals[index].name),
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
                  final sp = ref.read(surveyProvider);
                  ref
                      .read(userProvider)
                      .addTags(sp.allMeals[index].tags, isLike);

                  sp.removeMealAtIndex(index);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 20);
            },
            itemCount: surveyMealProvider.allMeals.length,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 1.55,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  final sp = ref.read(surveyProvider);

                  if (sp.allMeals.isNotEmpty) {
                    ref.read(userProvider).addTags(sp.allMeals[0].tags, false);
                    sp.removeMealAtIndex(0);
                  }
                },
                child: const Icon(Icons.thumb_down),
              ),
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  final sp = ref.read(surveyProvider);
                  if (sp.allMeals.isNotEmpty) {
                    ref.read(userProvider).addTags(sp.allMeals[0].tags, true);
                    sp.removeMealAtIndex(0);
                  }
                },
                child: const Icon(Icons.thumb_up),
              ),
              const Spacer(),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '${surveyMealProvider.allMeals.length}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(width: 4),
              const Text('swipes to go!')
            ]),
          ),
        ),
      ],
    );
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 12,
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                  Positioned.fill(
                    bottom: 0,
                    left: -2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).shadowColor.withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Text(
                            meal.name,
                            style: Theme.of(context).textTheme.headline2,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
