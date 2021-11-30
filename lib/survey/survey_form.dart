import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/ingredients.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/sign_in/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SurveyForm extends ConsumerStatefulWidget {
  const SurveyForm({Key? key}) : super(key: key);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends ConsumerState<SurveyForm> {
  late TextEditingController _adoreTextController;
  late TextEditingController _abhorTextController;
  bool _isLoading = false;

  @override
  void initState() {
    _adoreTextController = TextEditingController();
    _abhorTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Any allergies? 🤧',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        const Text('select all that apply'),
                        Wrap(
                          spacing: 12,
                          children: buildAllergyChips(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingredients you adore? 😍',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _adoreTextController,
                              decoration: const InputDecoration(
                                  labelText: 'Type ingredient')),
                          suggestionsCallback: (pattern) {
                            return Ingredients.getSuggestions(
                                ref, pattern, true);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion as String),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            ref
                                .read(userProvider)
                                .setAdoreIngredient(suggestion as String);
                            _adoreTextController.clear();
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Type ingredient';
                            }
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty) {
                              ref.read(userProvider).setAdoreIngredient(value);
                              _adoreTextController.clear();
                            }
                          },
                        ),
                        Wrap(
                          spacing: 12,
                          children: buildAdoreChips(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingredients you abhor? 😡',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _abhorTextController,
                              decoration: const InputDecoration(
                                  labelText: 'Type ingredient')),
                          suggestionsCallback: (pattern) {
                            return Ingredients.getSuggestions(
                                ref, pattern, false);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion as String),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            ref
                                .read(userProvider)
                                .setAbhorIngredient(suggestion as String);
                            _abhorTextController.clear();
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Type ingredient';
                            }
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty) {
                              ref.read(userProvider).setAbhorIngredient(value);
                            }
                          },
                        ),
                        Wrap(
                          spacing: 12,
                          children: buildAbhorChips(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
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
                  ref.read(settingsProvider).surveyIsDone
                      ? _save()
                      : Navigator.restorablePushNamed(
                          context, SignInView.routeName);
                },
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLoading
                          ? const CircularProgressIndicator()
                          : Text(ref.read(settingsProvider).surveyIsDone
                              ? 'SAVE'
                              : 'LET\'S GO'),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    _isLoading = true;

    var success = await ref.read(userProvider).saveUserData();

    if (success) {
      const snackBar = SnackBar(content: Text('Info updated!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    _isLoading = false;
  }

  List<Widget> buildAdoreChips() {
    List<Widget> chips = [];

    var uc = ref.watch(userProvider);

    for (var ingredient in uc.adoreIngredients()) {
      var chip = Chip(
        label: Text(ingredient),
        onDeleted: () {
          uc.removeAdoreIngredient(ingredient);
        },
      );
      chips.add(chip);
    }

    return chips;
  }

  List<Widget> buildAbhorChips() {
    List<Widget> chips = [];

    var uc = ref.watch(userProvider);

    for (var ingredient in uc.abhorIngredients()) {
      var chip = Chip(
        label: Text(ingredient),
        onDeleted: () {
          uc.removeAbhorIngredient(ingredient);
        },
      );
      chips.add(chip);
    }

    return chips;
  }

  List<Widget> buildAllergyChips() {
    List<Widget> chips = [];

    var uc = ref.watch(userProvider);

    uc.allergies().forEach((key, value) {
      var chip = FilterChip(
        label: Text(formatAllergy(key)),
        selected: uc.isAllergic(key),
        onSelected: (selected) {
          uc.setAllergy(allergy: key, isAllergic: selected);
        },
      );

      chips.add(chip);
    });

    return chips;
  }

  String formatAllergy(Allergy allergy) {
    switch (allergy) {
      case Allergy.treeNuts:
        return 'Tree Nuts';
      case Allergy.gluten:
        return 'Wheat/Gluten';
      default:
        var allergyString = allergy.toString().replaceAll('Allergy.', '');
        var firstLetter = allergyString[0].toUpperCase();
        var endOfWord = allergyString.substring(1);

        return firstLetter + endOfWord;
    }
  }
}
