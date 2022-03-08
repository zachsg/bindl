import 'package:bodai/features/discover_recipes/discover_recipes_view.dart';
import 'package:bodai/features/feed/feed_view.dart';
import 'package:bodai/features/profile/profile_view.dart';
import 'package:bodai/providers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bottomNavProvider = StateProvider<int>((_) => 0);

final tabLabelProvider = StateProvider<String>((ref) {
  switch (ref.watch(bottomNavProvider)) {
    case 0:
      return 'Feed';
    case 1:
      return 'Recipes';
    case 2:
      return 'Profile';
    default:
      return 'Feed';
  }
});

class BottomNavView extends HookConsumerWidget {
  const BottomNavView({Key? key}) : super(key: key);

  static const routeName = '/bottom_nav';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userProvider.notifier).load();
      return null;
    }, const []);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(ref.watch(tabLabelProvider)),
      // ),
      body: ref.watch(bottomNavProvider) == 0
          ? const FeedView()
          : ref.watch(bottomNavProvider) == 1
              ? const DiscoverRecipesView()
              : const ProfileView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(bottomNavProvider),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recipes'),
          BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Profile'),
        ],
        onTap: (index) => ref.read(bottomNavProvider.notifier).state = index,
      ),
    );
  }
}
