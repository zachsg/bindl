import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = PageController(viewportFraction: 1 / 1.2);

    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: PageView(
        controller: controller,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 4,
              child: Center(child: Text('Onboarding page 1')),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 4,
              child: Center(child: Text('Onboarding page 2')),
            ),
          ),
        ],
      ),
    );
  }
}
