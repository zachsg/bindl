import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/sign_in/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyForm extends ConsumerStatefulWidget {
  const SurveyForm({Key? key}) : super(key: key);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends ConsumerState<SurveyForm> {
  late TextEditingController _adoreTextController;
  late TextEditingController _abhorTextController;

  @override
  void initState() {
    _adoreTextController = TextEditingController();
    _abhorTextController = TextEditingController();
    super.initState();
  }

  var _selected = false;

  @override
  Widget build(BuildContext context) {
    return Form(
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
                TextFormField(
                  controller: _adoreTextController,
                  decoration:
                      const InputDecoration(hintText: 'Type ingredient'),
                ),
                Wrap(
                  spacing: 12,
                  children: [
                    Chip(
                      label: const Text('Orange'),
                      onDeleted: () {},
                    ),
                  ],
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
                TextFormField(
                  controller: _abhorTextController,
                  decoration:
                      const InputDecoration(hintText: 'Type ingredient'),
                ),
                Wrap(
                  spacing: 12,
                  children: [
                    Chip(
                      label: const Text('Plum'),
                      onDeleted: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.restorablePushNamed(context, SignInView.routeName);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Let\'s Go!'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    ));
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
