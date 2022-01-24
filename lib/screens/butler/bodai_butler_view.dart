import 'package:bodai/controllers/providers.dart';
import 'package:bodai/screens/butler/bodai_butler_widget.dart';
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
                return _educationAlert(context);
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
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: 16.0,
          ),
          child: _butlerBody(context, ref),
        ),
      ),
    );
  }

  Widget _butlerBody(BuildContext context, WidgetRef ref) {
    if (ref.watch(bestMealProvider).id == -1) {
      return _emptyState(context, ref);
    } else {
      return Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 12, left: 2, right: 2),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.restorablePushNamed(
                            context, SettingsView.routeName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Edit Prefs',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your Butler matched you to this meal based on your palate and prefs.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BodaiButlerWidget(parentRef: ref),
        ],
      );
    }
  }

  AlertDialog _educationAlert(BuildContext context) {
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
  }

  Widget _emptyState(BuildContext context, WidgetRef ref) {
    const message =
        'Your Butler couldn\'t find any new meals matching your palate yet 😴';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 8),
        ref.watch(userProvider).recipesLiked.isNotEmpty
            ? ElevatedButton(
                onPressed: () {
                  if (ref.read(userProvider).recipes.isNotEmpty) {
                    ref.read(bottomNavProvider.notifier).state = 2;
                  } else {
                    ref.read(bottomNavProvider.notifier).state = 1;
                  }
                },
                child: const Text('Let\'s Cook!'),
              )
            : const SizedBox(),
      ],
    );
  }
}
