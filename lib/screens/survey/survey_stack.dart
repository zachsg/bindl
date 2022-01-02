import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/models/xmodels.dart';
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
                child: SurveyMealCard(
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
              const Text('swipes to go!')
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
                          'Welcome to Bindl! 🎉',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Step 1: Swipe 👈 & 👉',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          'Swipe left & right depending on what you like. The algorithm will determine what to suggest for your weekly meal plan.',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Step 2: Set Your Prefs 🍽',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          'Then you\'ll set your allergies, ingredients you love, and a few other preferences (extra personalizations).',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Step 3: It\'s Bindl Time 🧑‍💻',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          'Create an account and you\'ll be instantly shown recipes specific to your palate (we promise it\'s quick and simple).',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Step 4: Cook. Cook. Cook. 🧑‍🍳',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          'That\'s it! Now all you\'ve gotta do is cook (your wallet...and your waistline are gonna thank you).',
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
                              child: const Text('LET\'S DO IT!'),
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
