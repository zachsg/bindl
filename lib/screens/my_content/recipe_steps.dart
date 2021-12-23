import 'package:bindl/controllers/xcontrollers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeSteps extends ConsumerStatefulWidget {
  const RecipeSteps({Key? key}) : super(key: key);

  @override
  _RecipeStepsState createState() => _RecipeStepsState();
}

class _RecipeStepsState extends ConsumerState<RecipeSteps> {
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
                  'Steps',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListView.builder(
            shrinkWrap: true,
            restorationId: 'sampleItemListView', // listview to restore position
            itemCount: rp.steps.length,
            itemBuilder: (BuildContext context3, int index) {
              final step = rp.steps[index];

              return Text('${index + 1}. $step');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: 6,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    labelText: 'Step...',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    var step = _textController.text;
                    if (!step.endsWith('.')) {
                      step += '.';
                    }
                    ref.read(recipeProvider).addStep(step);
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
