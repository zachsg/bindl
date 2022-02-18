import 'package:bodai/features/sign_in/sign_in_view.dart';
import 'package:bodai/shared_controllers/providers.dart';
import '../survey_controller.dart';
import 'survey_meal_card_widget.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showOnboardingCardProvider = StateProvider<bool>((_) => true);

class SurveyStackWidget extends ConsumerWidget {
  const SurveyStackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _educationBox(context),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 72),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _dismissibleSurveyMealCard(index, context, ref);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 20);
            },
            itemCount: ref.watch(surveyProvider).all.length,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 1.5,
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
                  '${ref.watch(surveyProvider).all.length}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(width: 4),
                const Text(swipesLeftLabel)
              ],
            ),
          ),
        ),
        ref.watch(showOnboardingCardProvider)
            ? Positioned.fill(child: _getOnboardingCard(context, ref))
            : const SizedBox(),
      ],
    );
  }

  Widget _educationBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.white),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Swipe based on what appeals to you. '
                  'We\'ll sort out your dietary restrictions & allergies later!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
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
            if (ref.read(surveyProvider).all.isNotEmpty) {
              ref
                  .read(userProvider.notifier)
                  .addTags(ref.read(surveyProvider).all[0].tags, false);
              ref.read(surveyProvider).removeAtIndex(0);
            }
          },
          child: const Icon(Icons.thumb_down),
        ),
        const Spacer(),
        FloatingActionButton(
          heroTag: 'surveyThumbUp',
          onPressed: () {
            if (ref.read(surveyProvider).all.isNotEmpty) {
              ref
                  .read(userProvider.notifier)
                  .addTags(ref.read(surveyProvider).all[0].tags, true);
              ref.read(surveyProvider).removeAtIndex(0);
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
      child: SurveyMealCardWidget(meal: ref.watch(surveyProvider).all[index]),
      key: ValueKey<String>(ref.watch(surveyProvider).all[index].name),
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
            .read(userProvider.notifier)
            .addTags(ref.read(surveyProvider).all[index].tags, isLike);
        ref.read(surveyProvider).removeAtIndex(index);
      },
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
                                    .read(showOnboardingCardProvider.notifier)
                                    .state = false;
                              },
                              child: const Text(letsGoLabel),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await ref
                                    .read(userProvider.notifier)
                                    .setHasAccount(true);

                                Navigator.pushNamedAndRemoveUntil(context,
                                    SignInView.routeName, (r) => false);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bubble_chart,
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.2),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    haveAccountLabel,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.3),
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
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
