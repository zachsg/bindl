import 'package:bindl/meal_plan/ingredient.dart';
import 'package:bindl/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealPlanDetailsView extends ConsumerWidget {
  const MealPlanDetailsView({
    Key? key,
    required this.id,
  }) : super(key: key);

  static const routeName = '/meal_details';

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var meal = ref.read(mealPlanProvider).mealForID(id);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 350.0,
              floating: true,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  meal.name,
                  style: Theme.of(context).textTheme.overline,
                ),
                background: Image(
                  image: NetworkImage(meal.imageURL),
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
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
                          return stepRow(context, stepNumber, step);
                        }
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
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
        Text(
          '${ingredient.quantity}',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          ' $measurementFormatted',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          ' ${ingredient.name}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
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
          Text(
            '$stepNumber. $step',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }

  Widget stepRow(BuildContext context, int stepNumber, String step) {
    return Text(
      '$stepNumber. $step',
      style: Theme.of(context).textTheme.bodyText2,
    );
  }
}
