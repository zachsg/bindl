import 'package:bodai/features/feed/feed_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterFeedByWidget extends ConsumerWidget {
  const FilterFeedByWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Relevance & recency'),
          leading: Radio<int>(
            value: 0,
            groupValue: ref.watch(filterFeedByProvider),
            onChanged: (int? value) {
              ref.read(filterFeedByProvider.notifier).state = 0;
              ref.read(feedProvider.notifier).loadFeed();
            },
          ),
        ),
        ListTile(
          title: const Text('Only people I follow'),
          leading: Radio<int>(
            value: 1,
            groupValue: ref.watch(filterFeedByProvider),
            onChanged: (int? value) {
              ref.read(filterFeedByProvider.notifier).state = 1;
              ref.read(feedProvider.notifier).loadFeedFromUsers();
            },
          ),
        ),
      ],
    );
  }
}
