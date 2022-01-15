import 'package:bodai/screens/meal_plan/bodai_butler_widget.dart';
import 'package:bodai/screens/meal_plan/tutorial_card_widget.dart';
import 'package:bodai/screens/settings/settings_view.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BodaiButlerView extends ConsumerWidget {
  const BodaiButlerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.lightbulb_outline),
          tooltip: educationLabel,
          onPressed: () async {
            return showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(educationHeaderLabel),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          educationBodyOneLabel,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          educationBodyTwoLabel,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(educationButtonLabel),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: const Text(butlerLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.face),
            tooltip: preferencesLabel,
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 20.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.restorablePushNamed(
                                  context, SettingsView.routeName);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Your Butler matched you to this meal based on your palate and prefs',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const BodaiButlerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
