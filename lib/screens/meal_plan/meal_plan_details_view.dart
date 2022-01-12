import 'package:bodai/controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/utils/helpers.dart';
import 'package:bodai/utils/strings.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
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
    var meal = ref.watch(mealsProvider.notifier).mealForID(widget.id);

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
                          const SizedBox(width: 40),
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
                    itemCount: meal.steps.length + 1,
                    controller: PageController(viewportFraction: 0.8),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == meal.steps.length) {
                        return mealDetailsInfoCard(meal);
                      } else {
                        return stepRow(context, index + 1, meal.steps[index]);
                      }
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Spacer(),
                discussionButton(meal),
                const Spacer(),
                ingredientsButton(meal),
                const Spacer(),
                ratingWidget(context, meal),
                const Spacer(),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget ingredientsButton(Meal meal) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).cardColor,
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 20,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
      onPressed: () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.70,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          builder: (BuildContext context2) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        ingredientsLabel,
                        style: Theme.of(context2).textTheme.headline6,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListView.builder(
                      itemCount: meal.ingredients.length,
                      itemBuilder: (context, index) {
                        var ingredient = meal.ingredients[index];

                        return getIngredientRow(
                          ingredient,
                          context,
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info),
                    Text(
                      boldLabel,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      ' $indicatesRequiredLabel',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          ingredientsLabel.toUpperCase(),
          style: Theme.of(context).textTheme.headline3?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }

  Widget discussionButton(Meal meal) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
        primary: Theme.of(context).cardColor,
      ),
      onPressed: () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.70,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          builder: (BuildContext context2) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        globalDiscussionLabel,
                        style: Theme.of(context2).textTheme.headline6,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => Navigator.pop(context2),
                      ),
                    ],
                  ),
                  Expanded(
                    child: DiscussionWidget(meal: meal),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(
          Icons.insert_comment,
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget mealDetailsInfoCard(Meal meal) {
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
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'i',
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder<User>(
                              future: ref
                                  .read(mealPlanProvider)
                                  .getUserWithID(meal.owner),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return const Text(loadingLabel);
                                } else {
                                  final user = snapshot.data;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        createdByLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.only(
                                              left: 4.0,
                                              top: 0.0,
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          '@${user?.name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$cookTimeLabel: ${meal.duration} $minLabel',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$servingsLabel: ${ref.watch(userProvider).servings}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$rateReminderLabel ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(fontStyle: FontStyle.italic),
                                ),
                                const Icon(Icons.south),
                              ],
                            ),
                          ],
                        ),
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

  Widget ratingWidget(BuildContext context, Meal meal) {
    var up = ref.watch(userProvider);
    var bp = ref.watch(bottomNavProvider);

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(0),
          primary: Theme.of(context).cardColor),
      child: DropdownButton(
        borderRadius: BorderRadius.circular(10),
        value: bp == 0 ? 0 : up.getRating(meal.id),
        icon: const SizedBox(),
        underline: const SizedBox(),
        items: [
          DropdownMenuItem(
            value: 0,
            enabled: up.getRating(meal.id) ==
                    Rating.values.indexOf(Rating.neutral) ||
                bp == 0,
            child: Icon(
              Icons.thumbs_up_down,
              color: up.getRating(meal.id) ==
                          Rating.values.indexOf(Rating.neutral) ||
                      bp == 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondaryVariant,
            ),
          ),
          DropdownMenuItem(
            value: 1,
            child: Icon(
              Icons.thumb_up,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: Icon(
              Icons.thumb_down,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        onChanged: (value) async {
          Rating rating;
          switch (value) {
            case 1:
              rating = Rating.like;
              break;
            case 2:
              rating = Rating.dislike;
              break;
            default:
              rating = Rating.neutral;
          }
          if (rating != Rating.neutral) {
            await _confirmRatingDialog(rating);
          }
        },
      ),
    );
  }

  ListTile getIngredientRow(Ingredient ingredient, BuildContext context) {
    var isOptional = ingredient.name.contains(optionalLabel);

    var ingredientName = ingredient.name.trim().capitalize();

    var measurementFormatted =
        ingredient.measurement.name.replaceAll(itemLabel, '').trim();

    var isItem = ingredient.measurement.name.contains(itemLabel);

    var meal = ref.watch(mealsProvider.notifier).mealForID(widget.id);

    var quantityWithServings =
        ingredient.quantity / meal.servings * ref.watch(userProvider).servings;

    var quantity = isInteger(quantityWithServings)
        ? quantityWithServings.toInt()
        : double.parse(quantityWithServings.toStringAsFixed(2))
            .toFractionString();

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      visualDensity: const VisualDensity(vertical: -2.0),
      title: Wrap(
        children: [
          isOptional
              ? Text(
                  ingredientName.replaceAll(optionalLabel, '').trim(),
                  style: Theme.of(context).textTheme.bodyText2,
                )
              : Text(
                  ingredientName,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
          Text(
            ' ($quantity',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            isItem ? '$measurementFormatted)' : ' $measurementFormatted)',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }

  Widget stepRow(BuildContext context, int stepNumber, String step) {
    var stepAndTips = step.split(tipLabel);

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
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
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
                      child: stepAndTips.length == 1
                          ? SingleChildScrollView(
                              child: Text(
                                stepAndTips[0].trim(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    stepAndTips[0].trim(),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    stepAndTips[1].trim(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
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
    var meal = ref.watch(mealsProvider.notifier).mealForID(widget.id);

    var title = rating == Rating.like
        ? moreLikeThisHeadingLabel
        : lessLikeThisHeadingLabel;

    var message = rating == Rating.like
        ? '$moreLikeThisBodyPartOneLabel ${meal.name.toLowerCase()}$moreLikeThisBodyPartTwoLabel'
        : '$lessLikeThisBodyPartOneLabel ${meal.name.toLowerCase()} $lessLikeThisBodyPartTwoLabel';

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
              child: const Text(nopeLabel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(yupLabel),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                if (rating == Rating.like || rating == Rating.dislike) {
                  await ref
                      .read(userProvider)
                      .setRating(meal.id, meal.tags, rating);

                  ref.read(mealPlanProvider).load();

                  ref.read(shoppingListProvider).buildUnifiedShoppingList(ref);

                  ref.read(mealHistoryProvider.notifier).add(meal);

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
