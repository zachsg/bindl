import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ratingProvider = StateProvider<int>((_) => 0);

class RatingButtonWidget extends ConsumerWidget {
  const RatingButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RatingBar.builder(
      initialRating: 0,
      itemCount: 5,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Icon(
              ref.watch(ratingProvider) >= 1 ? Icons.star : Icons.star_outline,
              color: Theme.of(context).colorScheme.primary,
            );
          case 1:
            return Icon(
              ref.watch(ratingProvider) >= 2 ? Icons.star : Icons.star_outline,
              color: Theme.of(context).colorScheme.primary,
            );
          case 2:
            return Icon(
              ref.watch(ratingProvider) >= 3 ? Icons.star : Icons.star_outline,
              color: Theme.of(context).colorScheme.primary,
            );
          case 3:
            return Icon(
              ref.watch(ratingProvider) >= 4 ? Icons.star : Icons.star_outline,
              color: Theme.of(context).colorScheme.primary,
            );
          case 4:
            return Icon(
              ref.watch(ratingProvider) >= 5 ? Icons.star : Icons.star_outline,
              color: Theme.of(context).colorScheme.primary,
            );
        }

        return Icon(
          ref.watch(ratingProvider) >= 1 ? Icons.star : Icons.star_outline,
          color: Theme.of(context).colorScheme.primary,
        );
      },
      onRatingUpdate: (rating) {
        ref.read(ratingProvider.notifier).state = rating.toInt();
      },
    );
  }
}
