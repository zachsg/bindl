import 'package:bindl/meal_plan/ingredient.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/shared/rating.dart';
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
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  expandedHeight: 350.0,
                  floating: false,
                  pinned: true,
                  snap: false,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).shadowColor.withOpacity(0.4),
                      child: Row(
                        children: [
                          const SizedBox(width: 32),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: Text(
                                meal.name,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                        ],
                      ),
                    ),
                    background: Image(
                      image: NetworkImage(meal.imageURL),
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  actions: [
                    DropdownButton(
                      value: ref.watch(userProvider).getRating(meal.id),
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Icon(Icons.feedback),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Icon(Icons.thumb_down),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Icon(Icons.thumb_up),
                        ),
                      ],
                      onChanged: (value) async {
                        Rating rating;
                        switch (value) {
                          case 1:
                            rating = Rating.dislike;
                            break;
                          case 2:
                            rating = Rating.like;
                            break;
                          default:
                            rating = Rating.neutral;
                        }
                        await ref.read(userProvider).setRating(meal.id, rating);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 8),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 32.0),
            //   child:
            //       Text('Steps', style: Theme.of(context).textTheme.headline3),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 0,
                  bottom: 16,
                ),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: meal.steps.length,
                    itemBuilder: (context, index) {
                      return stepRow(context, index + 1, meal.steps[index]);
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context2) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Text(
                                    'Ingredients',
                                    style:
                                        Theme.of(context2).textTheme.headline6,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () => Navigator.pop(context2),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: ListView.builder(
                                  itemCount: meal.ingredients.length,
                                  itemBuilder: (context, index) {
                                    var ingredient = meal.ingredients[index];
                                    var measurementFormatted = ingredient
                                        .measurement
                                        .toString()
                                        .replaceAll('Measurement.', '');

                                    return Row(
                                      children: [
                                        Text(
                                          ingredient.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Text(
                                          ' (${ingredient.quantity}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        Text(
                                          ' $measurementFormatted)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('SHOW INGREDIENTS'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget stepRow(BuildContext context, int stepNumber, String step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width / 1.3,
        child: Card(
          elevation: 4,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).cardColor,
                        child: Text(
                          '$stepNumber',
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    step,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
