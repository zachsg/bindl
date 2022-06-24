import 'package:bodai/providers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared_widgets/xshared_widget.dart';
import '../my_about/my_about_widget.dart';
import '../my_recipes/edit_recipe_controller.dart';
import '../my_recipes/edit_recipe_view.dart';
import '../my_recipes/widgets/my_recipes_widget.dart';
import 'widgets/profile_heading_widget.dart';

final currentProfileTabProvider = StateProvider<int>((ref) => 0);

class MyProfileView extends HookConsumerWidget {
  const MyProfileView({super.key});

  static const routeName = '/profile';

  final List<Widget> _tabs = const [
    Tab(
      icon: Icon(Icons.info),
      child: Text('About'),
    ),
    Tab(
      icon: Icon(Icons.palette),
      child: Text('Cookbook'),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTabController(initialLength: _tabs.length);
    final key = GlobalKey();

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
                    expandedHeight: 250,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const ProfileHeadingWidget(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Text(
                              ref.watch(userProvider).name,
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              '@${ref.watch(userProvider).handle}',
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
                        controller: controller,
                        tabs: _tabs,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        labelColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                ];
              },
              body: TabBarView(
                key: key,
                controller: controller
                  ..addListener(() {
                    switch (controller.index) {
                      case 0:
                        ref.read(currentProfileTabProvider.notifier).state = 0;
                        break;
                      case 1:
                        ref.read(currentProfileTabProvider.notifier).state = 1;
                        break;
                      default:
                        ref.read(currentProfileTabProvider.notifier).state = 0;
                    }
                  }),
                children: const [
                  MyAboutWidget(),
                  MyRecipesWidget(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: ref.watch(currentProfileTabProvider) == 1
            ? FloatingActionButton(
                onPressed: () {
                  ref.read(editRecipeProvider.notifier).reset();

                  context.goNamed(EditRecipeView.routeName);
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
