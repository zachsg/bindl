import 'dart:async';

import 'package:bodai/controllers/xcontrollers.dart';
import 'package:bodai/utils/strings.dart';
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
  final ScrollController _controller = ScrollController();

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
                      startConversationLabel,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  )
                : SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
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
                            leading: Icon(
                              Icons.smart_toy,
                              size: 30,
                              color: Theme.of(context).colorScheme.primary,
                            ),
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
                            leading: Icon(
                              Icons.self_improvement,
                              size: 30,
                              color: Theme.of(context).colorScheme.primary,
                            ),
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
                    onTap: () => Timer(
                      const Duration(milliseconds: 300),
                      () => _controller.jumpTo(
                        _controller.position.maxScrollExtent,
                      ),
                    ),
                    onSubmitted: (value) async {
                      if (_textController.text.isNotEmpty) {
                        var message = _textController.text;

                        await ref
                            .read(mealPlanProvider)
                            .addComment(meal.id, message);

                        _textController.clear();

                        FocusScope.of(context).unfocus();

                        Timer(
                          const Duration(milliseconds: 500),
                          () => _controller
                              .jumpTo(_controller.position.maxScrollExtent),
                        );
                      }
                    },
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                      labelText: addCommentLabel,
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

                      FocusScope.of(context).unfocus();

                      Timer(
                        const Duration(milliseconds: 500),
                        () => _controller
                            .jumpTo(_controller.position.maxScrollExtent),
                      );
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
