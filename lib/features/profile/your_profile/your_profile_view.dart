import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/other_user_controller.dart';
import '../../../providers/providers.dart';
import '../../shared_widgets/xshared_widget.dart';
import '../your_about/your_about_widget.dart';
import '../your_recipes/your_recipes_widget.dart';
import 'your_profile_heading_widget.dart';

class YourProfileView extends HookConsumerWidget {
  const YourProfileView({Key? key}) : super(key: key);

  static const routeName = '/your_profile';

  final List<Widget> _tabs = const [
    Tab(
      icon: Icon(Icons.info),
      child: Text('About'),
    ),
    Tab(
      icon: Icon(Icons.palette),
      child: Text('Recipes'),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useTabController(initialLength: _tabs.length);
    final _key = GlobalKey();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    expandedHeight: 250,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const YourProfileHeadingWidget(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Text(
                              ref.watch(otherUserProvider).name,
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              '@${ref.watch(otherUserProvider).handle}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottom: ColoredTabBar(
                      Theme.of(context).colorScheme.background,
                      TabBar(
                        controller: _controller,
                        tabs: _tabs,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        labelColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                ];
              },
              body: TabBarView(
                key: _key,
                controller: _controller
                  ..addListener(() {
                    switch (_controller.index) {
                      case 0:
                        ref.read(currentYourProfileTabProvider.notifier).state =
                            0;
                        break;
                      case 1:
                        ref.read(currentYourProfileTabProvider.notifier).state =
                            1;
                        break;
                      default:
                        ref.read(currentYourProfileTabProvider.notifier).state =
                            0;
                    }
                  }),
                children: const [
                  YourAboutWidget(),
                  YourRecipesWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
