import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/other_user_controller.dart';
import '../your_contributions/your_contributions_widget.dart';
import '../your_liked_posts/your_liked_posts_widget.dart';
import '../your_recipes/your_recipes_widget.dart';
import 'your_profile_heading_widget.dart';

final currentYourProfileTabProvider = StateProvider<int>((ref) => 0);

// TODO: Set otherUserIdProvider whenever navigating to another user's profile
final otherUserIdProvider = StateProvider<String>((ref) => '');

class MyProfileView extends HookConsumerWidget {
  const MyProfileView({Key? key}) : super(key: key);

  static const routeName = '/profile';

  final List<Widget> _tabs = const [
    Tab(
      icon: Icon(Icons.favorite),
      child: Text('Liked'),
    ),
    Tab(
      icon: Icon(Icons.create),
      child: Text('Contributions'),
    ),
    Tab(
      icon: Icon(Icons.menu_book),
      child: Text('Recipes'),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useTabController(initialLength: _tabs.length);
    final _key = GlobalKey();

    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  expandedHeight: 335,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.emoji_events),
                              Text(
                                ' Skill level: ${ref.watch(otherUserProvider).experience.name}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            ref.watch(otherUserProvider).bio,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  bottom: ColoredTabBar(
                    Theme.of(context).colorScheme.background,
                    TabBar(
                      controller: _controller,
                      tabs: _tabs,
                      unselectedLabelColor: Colors.black,
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
                    case 2:
                      ref.read(currentYourProfileTabProvider.notifier).state =
                          2;
                      break;
                    default:
                      ref.read(currentYourProfileTabProvider.notifier).state =
                          0;
                  }
                }),
              children: const [
                YourLikedPostsWidget(),
                YourContributionsWidget(),
                YourRecipesWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
