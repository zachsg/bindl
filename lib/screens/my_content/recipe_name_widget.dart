import 'package:bodai/controllers/providers.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeNameWidget extends ConsumerStatefulWidget {
  const RecipeNameWidget({Key? key}) : super(key: key);

  @override
  _RecipeNameState createState() => _RecipeNameState();
}

class _RecipeNameState extends ConsumerState<RecipeNameWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textController =
        TextEditingController(text: ref.watch(recipeProvider).name);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textController,
        minLines: 1,
        maxLines: 6,
        textCapitalization: TextCapitalization.sentences,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          labelText: recipeNameLabel,
        ),
        onChanged: (value) {
          ref.read(recipeProvider).setName(value);
        },
      ),
    );
  }
}
