import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../edit_recipe_controller.dart';

class RecipeStepsWidget extends HookConsumerWidget {
  const RecipeStepsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _stepController = useTextEditingController();
    final _tipController = useTextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Recipe steps',
            style: TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(height: 8),
        const RecipeStepsListWidget(),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _stepController,
                      minLines: 1,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Step',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _tipController,
                      minLines: 1,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Step Tip (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_stepController.text.isEmpty) {
                    return;
                  }
                  ref
                      .read(editRecipeProvider.notifier)
                      .addStep(_stepController.text, _tipController.text);

                  _stepController.clear();
                  _tipController.clear();
                },
                icon: Icon(
                  Icons.add_circle,
                  size: 36,
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

class RecipeStepsListWidget extends ConsumerWidget {
  const RecipeStepsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReorderableListView(
      key: UniqueKey(),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        for (int index = 0;
            index < ref.watch(editRecipeProvider).steps.length;
            index++)
          Container(
            key: ValueKey(ref.watch(editRecipeProvider).steps[index].step),
            child: RecipeDismissibleStepWidget(index: index),
          )
      ],
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item =
            ref.read(editRecipeProvider.notifier).removeStepAtIndex(oldIndex);
        ref.read(editRecipeProvider.notifier).insertStepAtIndex(newIndex, item);
      },
    );
  }
}

class RecipeDismissibleStepWidget extends HookConsumerWidget {
  const RecipeDismissibleStepWidget({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(editRecipeProvider).steps[index];

    final _stepController = useTextEditingController(text: step.step);
    final _tipController = useTextEditingController(text: step.tip);

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        ref.read(editRecipeProvider.notifier).removeStepAtIndex(index);
      },
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
      child: ListTile(
        key: Key('$index'),
        trailing: const Icon(Icons.reorder),
        title: TextField(
          controller: _stepController,
          textInputAction: TextInputAction.done,
          minLines: 1,
          maxLines: 8,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            ref
                .read(editRecipeProvider.notifier)
                .updateStepAtIndex(update: value, index: index);
          },
          onSubmitted: (value) {},
          decoration: InputDecoration(
            isDense: true,
            labelText: 'Step ${index + 1}',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextField(
            controller: _tipController,
            textInputAction: TextInputAction.done,
            minLines: 1,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              ref
                  .read(editRecipeProvider.notifier)
                  .updateTipAtIndex(update: value, index: index);
            },
            onSubmitted: (value) {},
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Step ${index + 1} tip (optional)',
            ),
          ),
        ),
      ),
    );
  }
}
