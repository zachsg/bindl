import 'package:bodai/models/experience.dart';
import 'package:bodai/providers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExperienceDropdownWidget extends ConsumerWidget {
  const ExperienceDropdownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text('Experience'),
        DropdownButton<Experience>(
          value: ref.watch(userProvider).experience,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          underline: Container(
            height: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          onChanged: (Experience? newValue) {
            if (newValue != null) {
              ref.read(userProvider.notifier).setExperience(newValue);
            }
          },
          items: <Experience>[
            Experience.novice,
            Experience.dabbler,
            Experience.cook,
            Experience.chef
          ].map<DropdownMenuItem<Experience>>((Experience experience) {
            return DropdownMenuItem<Experience>(
              value: experience,
              child: Text(experience.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}
