import 'dart:async';

import 'package:bodai/models/xmodels.dart';
import 'package:bodai/features/meal_plan/controllers/meal_plan_controller.dart';
import 'package:bodai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscussionWidget extends ConsumerStatefulWidget {
  const DiscussionWidget({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final Meal meal;

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
    var meal = widget.meal;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: meal.comments.isEmpty
                ? Center(
                    child: Text(
                      startConversationLabel,
                      textAlign: TextAlign.center,
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
                            .watch(mealPlanProvider.notifier)
                            .isMyMessage(comment.authorID, meal.owner)) {
                          return ListTile(
                            leading: Column(
                              children: [
                                const SizedBox(height: 8),
                                Icon(
                                  Icons.smart_toy,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                Text(
                                  'CHEF',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            title: Text(
                              comment.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                            subtitle: Text(
                              '@${comment.authorName}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        } else {
                          return ListTile(
                            leading: Column(
                              children: [
                                const SizedBox(height: 12),
                                Icon(
                                  Icons.self_improvement,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            title: Text(
                              comment.message,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            subtitle: Text(
                              '@${comment.authorName}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
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
                            .read(mealPlanProvider.notifier)
                            .addComment(meal, message);

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
                          .read(mealPlanProvider.notifier)
                          .addComment(meal, message);

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
