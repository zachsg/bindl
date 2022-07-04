import 'package:bodai/features/feed/create_post_view.dart';
import 'package:bodai/features/feed/widgets/filter_feed_by_widget.dart';
import 'package:bodai/features/feed/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'feed_controller.dart';

class FeedView extends HookConsumerWidget {
  const FeedView({super.key});

  static const routeName = '/feed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final future = useMemoized(() {
    //   if (ref.watch(discoverRecipesProvider).isEmpty) {
    //     ref.watch(discoverRecipesProvider.notifier).load();
    //   }

    //   return ref.watch(filterFeedByProvider) == 0
    //       ? ref.read(feedProvider.notifier).loadFeed
    //       : ref.read(feedProvider.notifier).loadFeedFromUsers;
    // });
    final future = useMemoized(ref.watch(filterFeedByProvider) == 0
        ? ref.read(feedProvider.notifier).loadFeed
        : ref.read(feedProvider.notifier).loadFeedFromUsers);
    final snapshot = useFuture(future);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        bottomOpacity: 0.0,
        elevation: 0,
        leading: IconButton(
          onPressed: () => _showMyDialog(
            context,
            'Filter Feed By',
            const FilterFeedByWidget(),
          ),
          icon: const Icon(Icons.filter_list),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: Locate new people to follow
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: SafeArea(
        child: snapshot.hasData
            ? ref.watch(feedProvider).isEmpty
                ? const Center(
                    child: Text(
                      'Feed empty',
                      style: TextStyle(fontSize: 30),
                    ),
                  )
                : ListView.builder(
                    restorationId: 'feedViewList',
                    itemCount: ref.watch(feedProvider).length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostCardWidget(
                          post: ref.watch(feedProvider)[index]);
                      // Text(ref.watch(feedProvider)[index].message);
                    },
                  )
            : const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(CreatePostView.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, String title, Widget widget) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: widget),
          actions: <Widget>[
            TextButton(
              child: const Text('Done!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
