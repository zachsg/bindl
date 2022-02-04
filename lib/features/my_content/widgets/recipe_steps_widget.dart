import 'package:bodai/features/my_content/widgets/recipe_step_editable_widget.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/recipe_controller.dart';

class RecipeStepsWidget extends ConsumerStatefulWidget {
  const RecipeStepsWidget({Key? key}) : super(key: key);

  @override
  _RecipeStepsState createState() => _RecipeStepsState();
}

class _RecipeStepsState extends ConsumerState<RecipeStepsWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var rp = ref.watch(recipeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rp.steps.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  stepsLabel,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ReorderableListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                for (int index = 0; index < rp.steps.length; index++)
                  Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      ref
                          .read(recipeProvider.notifier)
                          .removeStepAtIndex(index);
                    },
                    background: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: ListTile(
                      key: Key('$index'),
                      trailing: const Icon(Icons.reorder),
                      title: RecipeStepEditableWidget(
                        text: rp.steps[index],
                        index: index,
                      ),
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = ref
                    .read(recipeProvider.notifier)
                    .removeStepAtIndex(oldIndex);
                ref
                    .read(recipeProvider.notifier)
                    .insertStepAtIndex(newIndex, item);
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  textInputAction: TextInputAction.done,
                  minLines: 1,
                  maxLines: 6,
                  scrollPadding: const EdgeInsets.only(bottom: 80),
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (value) {},
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    labelText: stepLabel,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    var step = _textController.text;

                    ref.read(recipeProvider.notifier).addStep(step);

                    _textController.clear();
                  }
                },
                icon: Icon(
                  Icons.add_circle_outlined,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
