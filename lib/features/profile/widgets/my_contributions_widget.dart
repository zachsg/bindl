import 'package:bodai/features/profile/my_contributions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../feed/widgets/post_card_widget.dart';

class MyContributionsWidget extends HookConsumerWidget {
  const MyContributionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(myContributionsProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ListView.builder(
            restorationId:
                'myContributionsListView', // listview to restore position
            itemCount: ref.watch(myContributionsProvider).length,
            itemBuilder: (BuildContext context, int index) {
              return PostCardWidget(
                  post: ref.watch(myContributionsProvider)[index]);
              // Text(ref.watch(feedProvider)[index].message);
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
