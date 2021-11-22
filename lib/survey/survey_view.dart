import 'package:bindl/shared/tags.dart';
import 'package:bindl/survey/survey_meal.dart';
import 'package:flutter/material.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({Key? key}) : super(key: key);

  static const routeName = '/survey';

  @override
  _SurveyViewState createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  // late final

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: SurveyStack(),
        ),
      ),
    );
  }
}

class SurveyStack extends StatefulWidget {
  const SurveyStack({Key? key}) : super(key: key);

  @override
  _SurveyStackState createState() => _SurveyStackState();
}

class _SurveyStackState extends State<SurveyStack> {
  var _meals = [
    SurveyMeal(
      name: 'Ramen',
      image: 'assets/images/ramen.jpeg',
      tags: [Tag.asian],
    ),
    SurveyMeal(
      name: 'Beef Tacos',
      image: 'assets/images/beef_tacos.jpeg',
      tags: [Tag.asian],
    ),
  ];

  final List<SurveyMeal> _likedMeals = [];
  final List<SurveyMeal> _dislikedMeals = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              child: SurveyMealCard(meal: _meals[index]),
              key: ValueKey<String>(_meals[index].name),
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
                setState(() {
                  if (direction == DismissDirection.endToStart) {
                    _dislikedMeals.add(_meals[index]);
                  } else {
                    _likedMeals.add(_meals[index]);
                  }
                  _meals.removeAt(index);
                });
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 20);
          },
          itemCount: _meals.length,
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
                  if (_meals.isNotEmpty) {
                    setState(() {
                      _dislikedMeals.add(_meals[0]);
                      _meals.removeAt(0);
                    });
                  }
                },
                child: const Icon(Icons.thumb_down),
              ),
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  if (_meals.isNotEmpty) {
                    setState(() {
                      _likedMeals.add(_meals[0]);
                      _meals.removeAt(0);
                    });
                  }
                },
                child: const Icon(Icons.thumb_up),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> buildCardDeck() {
    List<SurveyMealCard> cards = [];

    for (var meal in _meals) {
      var surveyCard = SurveyMealCard(meal: meal);
      cards.add(surveyCard);
    }

    return cards;
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
