import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../edit_recipe_controller.dart';

class RecipePhotoWidget extends ConsumerWidget {
  const RecipePhotoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      iconSize: 64,
      padding: const EdgeInsets.all(0),
      onPressed: () async {
        final ImagePicker _picker = ImagePicker();

        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          var success =
              await ref.read(editRecipeProvider.notifier).setPhoto(image);

          if (!success) {
            const snackBar = SnackBar(
              content: Text('Failed to save photo'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      icon: ref.watch(editRecipeProvider).imageUrl.isEmpty
          ? Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primary,
            )
          : Image(
              image: NetworkImage(
                ref.watch(editRecipeProvider).imageUrl,
              ),
            ),
    );
  }
}
