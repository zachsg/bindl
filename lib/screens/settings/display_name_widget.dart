import 'package:bodai/controllers/xcontrollers.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayNameWidget extends ConsumerStatefulWidget {
  const DisplayNameWidget({Key? key}) : super(key: key);

  @override
  _DisplayNameWidgetState createState() => _DisplayNameWidgetState();
}

class _DisplayNameWidgetState extends ConsumerState<DisplayNameWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    ;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textController =
        TextEditingController(text: ref.watch(userProvider).displayName);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textController,
              textInputAction: TextInputAction.done,
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
                labelText: displayNameLabel,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_textController.text.isNotEmpty) {
                var displayName = _textController.text.trim();

                if (displayName.isNotEmpty) {
                  await ref.read(userProvider).updateDisplayName(displayName);

                  _textController.clear();

                  FocusScope.of(context).unfocus();

                  final snackBar = SnackBar(
                    content: Text('$displayName $updatedLabel'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
            icon: Icon(
              Icons.task_alt,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
