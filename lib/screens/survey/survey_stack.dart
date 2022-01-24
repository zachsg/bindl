import 'package:bodai/controllers/providers.dart';
import 'survey_meal_card_widget.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyStack extends ConsumerWidget {
  const SurveyStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _nayIndicator(context),
              const Spacer(),
              _yayIndicator(context),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _dismissibleSurveyMealCard(index, context, ref);
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
          child: _rateButtonRow(ref),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${ref.watch(surveyProvider).allMeals.length}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(width: 4),
                const Text(swipesLeftLabel)
              ],
            ),
          ),
        ),
        ref.watch(showOnboardingCarbProvider)
            ? Positioned.fill(child: _getOnboardingCard(context, ref))
            : const SizedBox(),
      ],
    );
  }

  Row _rateButtonRow(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        FloatingActionButton(
          heroTag: 'surveyThumbDown',
          onPressed: () {
            if (ref.read(surveyProvider).allMeals.isNotEmpty) {
              ref
                  .read(userProvider)
                  .addTags(ref.read(surveyProvider).allMeals[0].tags, false);
              ref.read(surveyProvider).removeMealAtIndex(0);
            }
          },
          child: const Icon(Icons.thumb_down),
        ),
        const Spacer(),
        FloatingActionButton(
          heroTag: 'surveyThumbUp',
          onPressed: () {
            if (ref.read(surveyProvider).allMeals.isNotEmpty) {
              ref
                  .read(userProvider)
                  .addTags(ref.read(surveyProvider).allMeals[0].tags, true);
              ref.read(surveyProvider).removeMealAtIndex(0);
            }
          },
          child: const Icon(Icons.thumb_up),
        ),
        const Spacer(),
      ],
    );
  }

  Dismissible _dismissibleSurveyMealCard(
      int index, BuildContext context, WidgetRef ref) {
    return Dismissible(
      child:
          SurveyMealCardWidget(meal: ref.watch(surveyProvider).allMeals[index]),
      key: ValueKey<String>(ref.watch(surveyProvider).allMeals[index].name),
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
        ref
            .read(userProvider)
            .addTags(ref.read(surveyProvider).allMeals[index].tags, isLike);

        ref.read(surveyProvider).removeMealAtIndex(index);
      },
    );
  }

  Row _yayIndicator(BuildContext context) {
    return Row(
      children: [
        Text(
          yayLabel,
          style: Theme.of(context)
              .textTheme
              .headline2
              ?.copyWith(color: Theme.of(context).colorScheme.secondaryVariant),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.redo,
          size: 36,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
        const SizedBox(width: 32),
      ],
    );
  }

  Row _nayIndicator(BuildContext context) {
    return Row(
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
          style: Theme.of(context)
              .textTheme
              .headline2
              ?.copyWith(color: Theme.of(context).colorScheme.secondaryVariant),
        ),
      ],
    );
  }

  Container _getOnboardingCard(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tutorialWelcomeLabel,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You\'re entering the place where cooking means simplicity and pleasure.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 24),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(showOnboardingCarbProvider.notifier)
                                    .state = false;
                              },
                              child: const Text(letsGoLabel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
