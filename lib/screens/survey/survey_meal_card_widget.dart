import 'package:bodai/models/xmodels.dart';
import 'package:flutter/material.dart';

class SurveyMealCardWidget extends StatelessWidget {
  const SurveyMealCardWidget({Key? key, required this.meal}) : super(key: key);

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
              child: meal.name.isEmpty ? fakeMeal(context) : realMeal(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget fakeMeal(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.91,
      ),
      child: Center(
        child: Text('Time to do a thing',
            style: Theme.of(context).textTheme.headline3),
      ),
    );
  }

  Stack realMeal(BuildContext context) {
    return Stack(
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
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
    );
  }
}
