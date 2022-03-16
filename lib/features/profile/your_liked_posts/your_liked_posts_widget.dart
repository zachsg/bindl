import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../feed/widgets/post_card_widget.dart';
import 'your_liked_posts_controller.dart';

class YourLikedPostsWidget extends HookConsumerWidget {
  const YourLikedPostsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(yourLikedPostsProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ListView.builder(
            restorationId:
                'myLikedPostsListView', // listview to restore position
            itemCount: ref.watch(yourLikedPostsProvider).length,
            itemBuilder: (BuildContext context, int index) {
              return PostCardWidget(
                  post: ref.watch(yourLikedPostsProvider)[index]);
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
