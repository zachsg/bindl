import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../feed/widgets/post_card_widget.dart';
import 'your_contributions_controller.dart';

class YourContributionsWidget extends HookConsumerWidget {
  const YourContributionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future =
        useMemoized(ref.read(yourContributionsProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ListView.builder(
            restorationId:
                'myContributionsListView', // listview to restore position
            itemCount: ref.watch(yourContributionsProvider).length,
            itemBuilder: (BuildContext context, int index) {
              return PostCardWidget(
                  post: ref.watch(yourContributionsProvider)[index]);
              // Text(ref.watch(feedProvider)[index].message);
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
