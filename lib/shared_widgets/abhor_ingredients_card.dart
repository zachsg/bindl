import 'package:bodai/shared_controllers/providers.dart';
import 'package:bodai/shared_models/xmodels.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AbhorIngredientsCard extends ConsumerStatefulWidget {
  const AbhorIngredientsCard({Key? key, this.shouldPersist = false})
      : super(key: key);

  final bool shouldPersist;

  @override
  _AbhorIngredientsCardState createState() => _AbhorIngredientsCardState();
}

class _AbhorIngredientsCardState extends ConsumerState<AbhorIngredientsCard> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ingredientsAbhorLabel,
              style: Theme.of(context).textTheme.headline2,
            ),
            TypeAheadFormField(
              keepSuggestionsOnSuggestionSelected: true,
              textFieldConfiguration: TextFieldConfiguration(
                controller: _textController,
                scrollPadding: const EdgeInsets.only(bottom: 200),
                decoration:
                    const InputDecoration(labelText: typeIngredientLabel),
              ),
              suggestionsCallback: (pattern) {
                return Ingredients.getSuggestions(ref: ref, pattern: pattern);
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
                await ref.read(userProvider.notifier).setAbhorIngredient(
                      ingredient: suggestion as String,
                      isAbhor: true,
                      shouldPersist: widget.shouldPersist,
                    );

                if (_textController.text.isEmpty) {
                  _textController.text = 'x';
                }

                _textController.clear();

                ScaffoldMessenger.of(context).showMaterialBanner(
                  MaterialBanner(
                    elevation: 4,
                    content: Text('You abhor $suggestion'),
                    actions: const [
                      SizedBox(),
                    ],
                  ),
                );

                Future.delayed(const Duration(milliseconds: 1500), () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                });
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return typeIngredientLabel;
                }
              },
              onSaved: (value) {},
            ),
            Wrap(
              spacing: 12,
              children: buildAbhorChips(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildAbhorChips() {
    List<Widget> chips = [];

    for (var ingredient in ref.watch(userProvider).abhorIngredients) {
      var chip = Chip(
        backgroundColor: Theme.of(context).colorScheme.primary,
        label: Text(ingredient),
        onDeleted: () async {
          await ref.read(userProvider.notifier).setAbhorIngredient(
                ingredient: ingredient,
                isAbhor: false,
                shouldPersist: widget.shouldPersist,
              );

          Ingredients.allSimple.add(ingredient);
        },
      );
      chips.add(chip);
    }

    return chips;
  }
}
