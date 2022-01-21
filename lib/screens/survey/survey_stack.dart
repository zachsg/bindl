import 'package:bodai/controllers/providers.dart';
import 'survey_meal_card_widget.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyStack extends ConsumerStatefulWidget {
  const SurveyStack({Key? key}) : super(key: key);

  @override
  _SurveyStack createState() => _SurveyStack();
}

class _SurveyStack extends ConsumerState<SurveyStack> {
  bool _showOnboardingCard = true;

  @override
  Widget build(BuildContext context) {
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
                    nayLabel,
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    yayLabel,
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
                child: SurveyMealCardWidget(
                    meal: ref.watch(surveyProvider).allMeals[index]),
                key: ValueKey<String>(
                    ref.watch(surveyProvider).allMeals[index].name),
                background: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3.5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Icon(Icons.thumb_up),
                      ),
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
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.thumb_down),
                      ),
                    ],
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  bool isLike = direction == DismissDirection.startToEnd;
                  ref.read(userProvider).addTags(
                      ref.read(surveyProvider).allMeals[index].tags, isLike);

                  ref.read(surveyProvider).removeMealAtIndex(index);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 20);
            },
            itemCount: ref.watch(surveyProvider).allMeals.length,
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
                  if (ref.read(surveyProvider).allMeals.isNotEmpty) {
                    ref.read(userProvider).addTags(
                        ref.read(surveyProvider).allMeals[0].tags, false);
                    ref.read(surveyProvider).removeMealAtIndex(0);
                  }
                },
                child: const Icon(Icons.thumb_down),
              ),
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  if (ref.read(surveyProvider).allMeals.isNotEmpty) {
                    ref.read(userProvider).addTags(
                        ref.read(surveyProvider).allMeals[0].tags, true);
                    ref.read(surveyProvider).removeMealAtIndex(0);
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
                '${ref.watch(surveyProvider).allMeals.length}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(width: 4),
              const Text(swipesLeftLabel)
            ]),
          ),
        ),
        _showOnboardingCard
            ? Positioned.fill(
                child: getOnboardingCard(context),
              )
            : const SizedBox(),
      ],
    );
  }

  Container getOnboardingCard(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showOnboardingCard = false;
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tutorialWelcomeLabel,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tutorialStepOneHeadingLabel,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          tutorialStepOneBodyLabel,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tutorialStepTwoHeadingLabel,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          tutorialStepTwoBodyLabel,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tutorialStepThreeHeadingLabel,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          tutorialStepThreeBodyLabel,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tutorialStepFourHeadingLabel,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          tutorialStepFourBodyLabel,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showOnboardingCard = false;
                                });
                              },
                              child: const Text(letsGoLabel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
