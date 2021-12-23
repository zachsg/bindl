import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeName extends ConsumerStatefulWidget {
  const RecipeName({Key? key}) : super(key: key);

  @override
  _RecipeNameState createState() => _RecipeNameState();
}

class _RecipeNameState extends ConsumerState<RecipeName> {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          labelText: 'Recipe Name',
        ),
      ),
    );
  }
}
