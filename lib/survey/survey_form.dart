import 'package:bindl/signin/sign_in_view.dart';
import 'package:flutter/material.dart';

class SurveyForm extends StatefulWidget {
  const SurveyForm({Key? key}) : super(key: key);

  @override
  State<SurveyForm> createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  late TextEditingController _adoreTextController;
  late TextEditingController _abhorTextController;

  @override
  void initState() {
    _adoreTextController = TextEditingController();
    _abhorTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _selected = false;

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
                  children: [
                    FilterChip(
                      selected: _selected,
                      label: const Text('Soy'),
                      onSelected: (selected) {
                        setState(() {
                          _selected = selected;
                        });
                      },
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
}
