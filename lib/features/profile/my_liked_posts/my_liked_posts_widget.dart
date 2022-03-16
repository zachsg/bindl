import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../feed/widgets/post_card_widget.dart';
import 'my_liked_posts_controller.dart';

class MyLikedPostsWidget extends HookConsumerWidget {
  const MyLikedPostsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(ref.read(myLikedPostsProvider.notifier).load);
    final snapshot = useFuture(future);

    return snapshot.hasData
        ? ListView.builder(
            restorationId:
                'myLikedPostsListView', // listview to restore position
            itemCount: ref.watch(myLikedPostsProvider).length,
            itemBuilder: (BuildContext context, int index) {
              return PostCardWidget(
                  post: ref.watch(myLikedPostsProvider)[index]);
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
