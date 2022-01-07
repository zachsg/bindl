import 'package:bodai/controllers/xcontrollers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscussionWidget extends ConsumerStatefulWidget {
  const DiscussionWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  _DiscussionWidgetState createState() => _DiscussionWidgetState();
}

class _DiscussionWidgetState extends ConsumerState<DiscussionWidget> {
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
    var meal = ref.watch(mealPlanProvider).mealForID(widget.id);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: meal.comments.isEmpty
                ? Center(
                    child: Text(
                      'Start the conversation! 👀',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  )
                : SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      restorationId:
                          'sampleItemListView', // listview to restore position
                      itemCount: meal.comments.length,
                      itemBuilder: (BuildContext context3, int index) {
                        var comment = meal.comments[index];

                        if (ref
                            .watch(mealPlanProvider)
                            .isMyMessage(comment.authorID, meal.owner)) {
                          return ListTile(
                            leading: const Text('🧑‍🍳'),
                            title: Text(
                              comment.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                            subtitle: Text(comment.authorName),
                          );
                        } else {
                          return ListTile(
                            leading: const Text('🧑‍🎓'),
                            title: Text(
                              comment.message,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            subtitle: Text(comment.authorName),
                          );
                        }
                      },
                    ),
                  ),
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
                      labelText: 'Add comment...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (_textController.text.isNotEmpty) {
                      var message = _textController.text;

                      await ref
                          .read(mealPlanProvider)
                          .addComment(meal.id, message);

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
      ),
    );
  }
}
