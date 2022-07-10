import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/xmodels.dart';
import '../../profile/your_profile/your_profile_view.dart';
import '../recipe_controller.dart';

class CreatorButtonWidget extends ConsumerWidget {
  CreatorButtonWidget({super.key});

  final creatorProvider = FutureProvider.autoDispose<User>((ref) async {
    final creator = await ref.read(recipeProvider.notifier).creator();

    return creator;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<User> creator = ref.watch(creatorProvider);

    return creator.when(
      data: (creator) {
        return ElevatedButton(
          onPressed: () {
            context.pushNamed(YourProfileView.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: creator.avatar.isEmpty
                      ? const SizedBox()
                      : CachedNetworkImage(
                          imageUrl: creator.avatar,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.face),
                        ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creator.name,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      '@${creator.handle}',
                      style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      error: (err, stack) => Text(err.toString()),
      loading: () => const Text('Loading...'),
    );
  }
}
