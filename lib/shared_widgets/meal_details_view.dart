import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:bodai/features/cookbook/controllers/cookbook_controller.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:bodai/features/meal_plan/controllers/pantry_controller.dart';
import 'package:bodai/shared_widgets/xwidgets.dart';
import 'package:bodai/utils/helpers.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mealStepExpandedProvider = StateProvider<bool>((_) => false);

class MealDetailsView extends ConsumerStatefulWidget {
  const MealDetailsView({
    Key? key,
    required this.id,
  }) : super(key: key);

  static const routeName = '/meal_details';

  final int id;

  @override
  _MealPlanDetailsView createState() => _MealPlanDetailsView();
}

class _MealPlanDetailsView extends ConsumerState<MealDetailsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => ref.read(mealStepExpandedProvider.notifier).state = false);
  }

  @override
  Widget build(BuildContext context) {
    var meal =
        ref.watch(mealsProvider).firstWhere((meal) => meal.id == widget.id);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: _sliverAppBar(context, meal),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _mealSteps(context, meal),
            _actionButtonBottomRow(meal, context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  SliverAppBar _sliverAppBar(BuildContext context, Meal meal) {
    return SliverAppBar(
      expandedHeight: 280.0,
      floating: true,
      pinned: true,
      snap: true,
      actions: [
        ref.watch(mealStepExpandedProvider)
            ? IconButton(
                icon: Icon(
                  Icons.insert_comment,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  _showDiscussionSheet(meal);
                },
              )
            : RawMaterialButton(
                onPressed: () {
                  _showDiscussionSheet(meal);
                },
                elevation: 2.0,
                fillColor: Theme.of(context).cardColor,
                child: Icon(
                  Icons.insert_comment,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: const EdgeInsets.all(0.0),
                shape: const CircleBorder(),
              ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
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
          );
        },
      ),
    );
  }

  void _showDiscussionSheet(Meal meal) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
  }

  Future<void> _confirmDeleteDialog(
      BuildContext context, WidgetRef ref, Meal meal) async {
    var title = 'Away With It!';

    var message =
        'Your Butler wants to confirm you\'d like to remove the ${meal.name} from your cookbook.';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(left: 24, top: 4.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              TextButton(
                child: const Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
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
              child: const Text('Remove From Cookbook'),
              onPressed: () async {
                ref.read(userProvider.notifier).removeFromCookbook(meal);

                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Expanded _mealSteps(BuildContext context, Meal meal) {
    return Expanded(
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
                return _mealInfoCard(meal);
              } else {
                return _mealStepCard(
                    context, index + 1, meal.steps[index], meal);
              }
            },
          ),
        ),
      ),
    );
  }

  Row _actionButtonBottomRow(Meal meal, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        const Spacer(),
        ref.watch(bottomNavProvider) == 1
            ? _deleteButton(meal)
            : const SizedBox(width: 32),
        const Spacer(),
        _ingredientsButton(meal),
        const Spacer(),
        _doneButton(context, meal),
        const Spacer(),
        const Spacer(),
      ],
    );
  }

  Widget _deleteButton(Meal meal) {
    return IconButton(
      onPressed: () async {
        await _confirmDeleteDialog(context, ref, meal);
      },
      icon: Icon(
        Icons.delete_outline,
        size: 32,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _ingredientsButton(Meal meal) {
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

                        return _getIngredientRow(ingredient, context);
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

  Widget _mealInfoCard(Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width / 1.3,
        child: GestureDetector(
          onTap: () {
            ref.read(mealStepExpandedProvider.notifier).state =
                !ref.read(mealStepExpandedProvider);

            _expandCard();
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
                                  .read(mealPlanProvider.notifier)
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
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.error_outline),
                                    Text(
                                      ' $rateReminderLabel ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                  ],
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

  Widget _mealStepCard(
      BuildContext context, int stepNumber, String step, Meal meal) {
    var stepAndTips = step.split(tipLabel);

    var stepText = _formatStep(stepAndTips.first, meal);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width / 1.3,
        child: GestureDetector(
          onTap: () {
            ref.read(mealStepExpandedProvider.notifier).state =
                !ref.read(mealStepExpandedProvider);

            _expandCard();
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
                                stepText.trim(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    stepText.trim(),
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

  Widget _doneButton(BuildContext context, Meal meal) {
    return IconButton(
      onPressed: () async {
        await _confirmRatingDialog(Rating.like);
      },
      icon: Icon(
        Icons.check_circle,
        size: 34,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  ListTile _getIngredientRow(Ingredient ingredient, BuildContext context) {
    var isOptional = ingredient.name.contains(optionalLabel);

    var ingredientName = ingredient.name.trim().capitalize();

    var measurementFormatted =
        ingredient.measurement.name.replaceAll(itemLabel, '').trim();

    var isItem = ingredient.measurement.name.contains(itemLabel);

    var meal =
        ref.watch(mealsProvider).firstWhere((meal) => meal.id == widget.id);

    var quantityWithServings =
        ingredient.quantity / meal.servings * ref.watch(userProvider).servings;

    var quantity = Helpers.isInteger(quantityWithServings)
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

  void _expandCard() {
    if (ref.watch(mealStepExpandedProvider)) {
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
    var meal =
        ref.watch(mealsProvider).firstWhere((meal) => meal.id == widget.id);

    bool _isLoading = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cooked It!'),
          content: SingleChildScrollView(
            child: _isLoading
                ? const CircularProgressIndicator()
                : ListBody(
                    children: <Widget>[
                      Text(
                        'I\'m done cooking the ${meal.name}',
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
                  var wasInMealPlan =
                      ref.read(userProvider).recipes.contains(meal.id);

                  await ref
                      .read(userProvider.notifier)
                      .setRating(meal.id, meal.tags, rating);

                  if (ref.read(mealPlanProvider).isEmpty) {
                    ref.read(pantryProvider.notifier).clear();
                    ref.read(bottomNavProvider.notifier).state = 1;

                    if (wasInMealPlan) {
                      const snackBar = SnackBar(
                        content: Text('Meal plan completed! 🥳'),
                      );
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }

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

  String _formatStep(String stepText, Meal meal) {
    var servings = ref.read(userProvider).servings;

    var splitted = stepText.split(' ');

    for (var i = 0; i < splitted.length; i++) {
      var x = 0.0;

      if (double.tryParse(splitted[i]) != null) {
        if (i < splitted.length - 1) {
          if (Helpers.isNumber(splitted[i + 1])) {
            double second;
            if (Helpers.isFraction(splitted[i + 1])) {
              second = splitted[i + 1].toDouble();
            } else {
              second = double.parse(splitted[i + 1]);
            }

            x = double.parse(splitted[i]) + second;
            var z = x / meal.servings * servings;
            splitted[i] = z.toFractionString();
            splitted.removeAt(i + 1);
            continue;
          } else if (!Helpers.isIngredientQuantity(splitted[i + 1])) {
            continue;
          } else if (Helpers.isIngredientQuantity(splitted[i + 1])) {
            x = double.parse(splitted[i]);
          } else {
            continue;
          }
        }

        if (i < splitted.length - 1) {
          if (Helpers.isFraction(splitted[i + 1])) {
            var y = splitted[i + 1].toDouble();
            i += 1;

            var z = (x + y) / meal.servings * servings;
            splitted[i] = z.toFractionString();
            splitted.removeAt(i + 1);
          } else {
            var z = x / meal.servings * servings;
            splitted[i] = z.toFractionString();
          }
        } else {
          var z = x / meal.servings * servings;
          splitted[i] = z.toFractionString();
        }
      } else if (Helpers.isFraction(splitted[i])) {
        if (i < splitted.length - 1) {
          if (Helpers.isIngredientQuantity(splitted[i + 1])) {
            var y = splitted[i].toDouble();

            var z = y / meal.servings * servings;
            splitted[i] = z.toFractionString();
          }
        }
      }
    }

    return splitted.join(' ');
  }
}
