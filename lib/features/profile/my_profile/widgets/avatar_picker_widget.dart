import 'package:bodai/providers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final loadingAvatarProvider = StateProvider<bool>((ref) => false);

class AvatarPickerWidget extends HookConsumerWidget {
  const AvatarPickerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(loadingAvatarProvider)
        ? const CircularProgressIndicator()
        : GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 50,
                child: ref.watch(userProvider).avatar.isEmpty
                    ? Icon(
                        Icons.face,
                        size: 94,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      )
                    : ClipOval(
                        child: Image(
                          image: NetworkImage(ref.watch(userProvider).avatar),
                          fit: BoxFit.cover,
                          width: 88,
                          height: 88,
                        ),
                      ),
              ),
            ),
            onTap: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              ref.read(loadingAvatarProvider.notifier).state = true;

              final ImagePicker picker = ImagePicker();

              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                var success =
                    await ref.read(userProvider.notifier).setAvatar(image);

                if (!success) {
                  const snackBar = SnackBar(
                    content: Text('Failed to update avatar.'),
                  );
                  scaffoldMessenger.showSnackBar(snackBar);
                }
              }

              ref.read(loadingAvatarProvider.notifier).state = false;
            },
          );
  }
}
