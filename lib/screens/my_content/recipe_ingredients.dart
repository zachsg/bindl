import 'package:bindl/controllers/xcontrollers.dart';
import 'package:bindl/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class RecipeIngredients extends ConsumerStatefulWidget {
  const RecipeIngredients({Key? key}) : super(key: key);

  @override
  _RecipeStepsState createState() => _RecipeStepsState();
}

class _RecipeStepsState extends ConsumerState<RecipeIngredients> {
  late TextEditingController _quantityTextController;
  late TextEditingController _nameTextController;
  String _measurement = 'oz';

  @override
  void initState() {
    super.initState();
    _quantityTextController = TextEditingController();
    _nameTextController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var rp = ref.watch(recipeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rp.ingredients.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            restorationId: 'sampleItemListView', // listview to restore position
            itemCount: rp.ingredients.length,
            itemBuilder: (BuildContext context3, int index) {
              final ingredient = rp.ingredients[index];

              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  ref.read(recipeProvider).removeIngredientAtIndex(index);
                },
                background: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ],
                  ),
                ),
                child: ListTile(
                  key: Key('$index'),
                  title: Text(
                    '${ingredient.quantity} '
                    '${ingredient.measurement.name} '
                    '${ingredient.name}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: TextField(
                  controller: _quantityTextController,
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    labelText: 'Qty',
                  ),
                  onSubmitted: (value) {},
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                icon: const SizedBox.shrink(),
                iconSize: 0.0,
                underline: const SizedBox(),
                value: _measurement,
                onChanged: (measurement) {
                  if (measurement != null) {
                    setState(() {
                      _measurement = measurement;
                    });
                  }
                },
                items: Measurement.values.map((Measurement classType) {
                  return DropdownMenuItem<String>(
                      value: classType.name,
                      child: Text(
                        classType.name,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ));
                }).toList(),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 3,
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _nameTextController,
                    maxLines: 2,
                    minLines: 1,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                      labelText: 'Ingredient',
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return Ingredients.getSuggestions(
                        ref: ref, pattern: pattern, useFullList: true);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion as String),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) async {
                    _nameTextController.text = suggestion as String;
                  },
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Ingredient';
                    }
                  },
                  onSaved: (value) async {
                    if (value != null) {
                      _nameTextController.text = value;
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_nameTextController.text.isNotEmpty &&
                      _quantityTextController.text.isNotEmpty) {
                    var name = _nameTextController.text.toLowerCase().trim();

                    var quantity =
                        double.parse(_quantityTextController.text.trim());
                    var measurement = Measurement.values.where(
                        (measurement) => measurement.name == _measurement);

                    var ingredient = Ingredient(
                        name: name,
                        quantity: quantity,
                        measurement: measurement.first);

                    ref.read(recipeProvider).addIngredient(ingredient);

                    _quantityTextController.clear();
                    _nameTextController.clear();
                  }
                },
                icon: Icon(
                  Icons.add_circle_outlined,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
