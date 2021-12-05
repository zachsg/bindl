import 'package:bindl/meal_plan/meal_plan_view.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/shared/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealPlanDetailsView extends ConsumerStatefulWidget {
  const MealPlanDetailsView({
    Key? key,
    required this.id,
  }) : super(key: key);

  static const routeName = '/meal_details';

  final int id;

  @override
  _MealPlanDetailsView createState() => _MealPlanDetailsView();
}

class _MealPlanDetailsView extends ConsumerState<MealPlanDetailsView> {
  final _scrollController = ScrollController();
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    var meal = ref.read(mealPlanProvider).mealForID(widget.id);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  expandedHeight: 280.0,
                  floating: true,
                  pinned: true,
                  snap: true,
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
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    background: meal.imageURL.isEmpty
                        ? const SizedBox()
                        : Image(
                            image: NetworkImage(meal.imageURL),
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: PageView.builder(
                    itemCount: meal.steps.length,
                    controller: PageController(viewportFraction: 0.8),
                    itemBuilder: (BuildContext context, int index) {
                      return stepRow(context, index + 1, meal.steps[index]);
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
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
                  child: const Text('INGREDIENTS'),
                ),
                const Spacer(),
                DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  value: ref.watch(userProvider).getRating(meal.id),
                  items: [
                    DropdownMenuItem(
                      value: 0,
                      enabled: false,
                      child: Icon(
                        Icons.thumbs_up_down,
                        color: ref.watch(userProvider).getRating(meal.id) ==
                                Rating.values.indexOf(Rating.neutral)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondaryVariant,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Icon(
                        Icons.thumb_down,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Icon(
                        Icons.thumb_up,
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
                    if (rating != Rating.neutral) {
                      await _confirmRatingDialog(rating);
                    }
                  },
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 40),
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
        child: GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
            expandCard(_expanded);
          },
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            elevation: 4,
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).cardColor,
                      child: Text(
                        '$stepNumber',
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 64,
                        bottom: 16,
                      ),
                      child: Text(
                        step,
                        style: Theme.of(context).textTheme.headline6,
                      ),
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

  void expandCard(bool expand) {
    if (expand) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    }
  }

  Future<void> _confirmRatingDialog(Rating rating) async {
    var meal = ref.read(mealPlanProvider).mealForID(widget.id);
    var title =
        rating == Rating.like ? 'More of This Please' : 'No More of This!';
    var message = rating == Rating.like
        ? 'I cooked the ${meal.name.toLowerCase()}... and it was awesome 🙌'
        : 'I don\'t want to see the ${meal.name.toLowerCase()} in my plan again 🤨';

    bool _isLoading = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: _isLoading
                ? const CircularProgressIndicator()
                : ListBody(
                    children: <Widget>[
                      Text(
                        message,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Just Kidding'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yup!'),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                if (rating == Rating.like || rating == Rating.dislike) {
                  var mp = ref.read(mealPlanProvider);
                  var uc = ref.read(userProvider);
                  await uc.setRating(meal.id, rating);

                  await uc.computeMealPlan();
                  await mp.loadMealsForIDs(uc.recipes());

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }

                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
