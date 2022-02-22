import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget(
      {Key? key,
      required this.text,
      required this.actionLabel,
      required this.action})
      : super(key: key);

  final String text;
  final String actionLabel;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => action(),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}
