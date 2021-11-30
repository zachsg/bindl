import 'package:bindl/meal_plan/ingredient.dart';
import 'package:bindl/meal_plan/meal.dart';
import 'package:flutter/material.dart';

class MealPlanDetailsView extends StatelessWidget {
  const MealPlanDetailsView({
    Key? key,
    required this.mealJson,
  }) : super(key: key);

  static const routeName = '/meal_details';

  final Map<String, dynamic> mealJson;

  @override
  Widget build(BuildContext context) {
    var meal = Meal.fromJson(mealJson);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: Column(
        children: [
          Image(
            image: NetworkImage(meal.imageURL),
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.builder(
                itemCount: meal.ingredients.length + meal.steps.length,
                itemBuilder: (context, index) {
                  if (index < meal.ingredients.length) {
                    var ingredient = meal.ingredients[index];
                    if (index == 0) {
                      return ingredientHeaderRow(context, ingredient);
                    } else {
                      return ingredientRow(context, ingredient);
                    }
                  } else {
                    var offset = meal.ingredients.length;
                    var stepNumber = index - offset + 1;
                    var step = meal.steps[index - offset];

                    if (index == meal.ingredients.length) {
                      return stepHeaderRow(context, stepNumber, step);
                    } else {
                      return stepRow(stepNumber, step);
                    }
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ingredientHeaderRow(BuildContext context, Ingredient ingredient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: Theme.of(context).textTheme.headline6,
        ),
        ingredientRow(context, ingredient),
      ],
    );
  }

  Widget ingredientRow(BuildContext context, Ingredient ingredient) {
    var measurementFormatted =
        ingredient.measurement.toString().replaceAll('Measurement.', '');

    return Row(
      children: [
        Text('${ingredient.quantity}'),
        Text(' $measurementFormatted'),
        Text(' ${ingredient.name}',
            style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }

  Widget stepHeaderRow(BuildContext context, int stepNumber, String step) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Steps',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text('$stepNumber. $step'),
        ],
      ),
    );
  }

  Widget stepRow(int stepNumber, String step) {
    return Text('$stepNumber. $step');
  }
}
