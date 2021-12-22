import 'package:flutter/material.dart';

class ProgressSpinner extends StatelessWidget {
  const ProgressSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(64.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
