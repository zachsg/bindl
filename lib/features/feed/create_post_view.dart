import 'package:bodai/features/feed/feed_controller.dart';
import 'package:bodai/features/feed/new_post_controller.dart';
import 'package:bodai/features/feed/widgets/post_message_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatePostView extends ConsumerWidget {
  const CreatePostView({Key? key}) : super(key: key);

  static const routeName = '/create_post';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final success =
                  await ref.read(newPostProvider.notifier).createPost();
              ref.read(feedProvider.notifier).loadFeed();

              if (!success) {
                const snackBar =
                    SnackBar(content: Text('Failed to create post.'));
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }

              Navigator.pop(context);
            },
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: const [
            SizedBox(height: 12),
            PostMessageTextFieldWidget(),
          ],
        ),
      ),
    );
  }
}
