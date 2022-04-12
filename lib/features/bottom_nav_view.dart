import 'package:bodai/features/discover_recipes/discover_recipes_view.dart';
import 'package:bodai/features/pantry/pantry_view.dart';
import 'package:bodai/features/profile/my_profile/my_profile_view.dart';
import 'package:bodai/providers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bottomNavProvider = StateProvider<int>((_) => 0);

final tabLabelProvider = StateProvider<String>((ref) {
  switch (ref.watch(bottomNavProvider)) {
    case 0:
      return 'Pantry';
    case 1:
      return 'Recipes';
    case 2:
      return 'Profile';
    default:
      return 'Pantry';
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
          ? const PantryView()
          : ref.watch(bottomNavProvider) == 1
              ? const DiscoverRecipesView()
              : const MyProfileView(),
      bottomNavigationBar: ref.watch(didOnboardingProvider)
          ? BottomNavigationBar(
              enableFeedback: true,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              selectedIconTheme: const IconThemeData(size: 28),
              unselectedIconTheme: const IconThemeData(size: 22),
              currentIndex: ref.watch(bottomNavProvider),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Kitchen'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book), label: 'Recipes'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.face), label: 'Profile'),
              ],
              onTap: (index) =>
                  ref.read(bottomNavProvider.notifier).state = index,
            )
          : null,
    );
  }
}
