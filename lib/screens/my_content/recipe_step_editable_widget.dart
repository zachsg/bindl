import 'package:bodai/controllers/providers.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeStepEditableWidget extends ConsumerStatefulWidget {
  const RecipeStepEditableWidget(
      {Key? key, required this.text, required this.index})
      : super(key: key);

  final String text;
  final int index;

  @override
  _RecipeStepEditableWidgetState createState() =>
      _RecipeStepEditableWidgetState();
}

class _RecipeStepEditableWidgetState
    extends ConsumerState<RecipeStepEditableWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.text = widget.text;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      textInputAction: TextInputAction.done,
      minLines: 1,
      maxLines: 8,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (value) {
        ref
            .read(recipeProvider)
            .updateStepAtIndex(text: value, index: widget.index);
      },
      onSubmitted: (value) {},
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
        isDense: true,
        labelText: '$stepLabel ${widget.index + 1}',
      ),
    );
  }
}
