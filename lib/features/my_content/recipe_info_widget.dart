import 'package:bodai/data/db.dart';
import 'package:bodai/utils/strings.dart';
import 'package:bodai/shared_widgets/progress_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'recipe_controller.dart';

class RecipeInfoWidget extends ConsumerStatefulWidget {
  const RecipeInfoWidget({Key? key}) : super(key: key);

  @override
  _RecipeInfoState createState() => _RecipeInfoState();
}

class _RecipeInfoState extends ConsumerState<RecipeInfoWidget> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _imagePicker(context),
              _servingsPicker(context),
              _cookTimePicker(context),
            ],
          ),
        ),
      ],
    );
  }

  Column _cookTimePicker(BuildContext context) {
    return Column(
      children: [
        Text(
          cookTimeLabel,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          icon: const SizedBox(),
          underline: const SizedBox(),
          value: ref.watch(recipeProvider).duration,
          onChanged: (duration) {
            if (duration != null) {
              ref.read(recipeProvider).setDuration(duration);
            }
          },
          items: <int>[
            10,
            15,
            20,
            25,
            30,
            35,
            40,
            45,
            50,
            55,
            60,
            75,
            90,
            120,
            180,
          ].map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                '$value $minLabel',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Column _servingsPicker(BuildContext context) {
    return Column(
      children: [
        Text(
          servingsLabel,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          icon: const SizedBox(),
          underline: const SizedBox(),
          value: ref.watch(recipeProvider).servings,
          onChanged: (servings) {
            if (servings != null) {
              ref.read(recipeProvider).setServings(servings);
            }
          },
          items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                value == 1 ? '$value $personLabel' : '$value $peopleLabel',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Column _imagePicker(BuildContext context) {
    return Column(
      children: [
        _loading
            ? const ProgressSpinner()
            : IconButton(
                iconSize: 64,
                padding: const EdgeInsets.all(0),
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });

                  final ImagePicker _picker = ImagePicker();

                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    var success = await DB.uploadRecipePhoto(image);

                    if (success) {
                      var imageURL =
                          await DB.getRecipePhotoURLForImage(image.name);

                      ref.read(recipeProvider).setImageURL(imageURL);
                    } else {
                      const snackBar = SnackBar(
                        content: Text(imageUploadFailedLabel),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }

                  setState(() {
                    _loading = false;
                  });
                },
                icon: ref.watch(recipeProvider).imageURL.isEmpty
                    ? Icon(
                        Icons.image,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : Image(
                        image: NetworkImage(
                          ref.watch(recipeProvider).imageURL,
                        ),
                      ),
              ),
      ],
    );
  }
}
