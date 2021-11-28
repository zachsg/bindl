import 'package:bindl/shared/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Ingredients {
  static final all = [
    'Apple',
    'Banana',
    'Grape',
    'Grapefruit',
    'Kiwi',
    'Orange',
    'Peach',
    'Pear',
    'Plum',
    'Watermelon',
  ];

  static List<String> getSuggestions(
      WidgetRef ref, String pattern, bool isAdore) {
    var matches = <String>[];
    var uc = ref.read(userProvider);

    for (var ingredient in all) {
      bool shouldInclude = true;

      if (isAdore) {
        for (var ingredient in uc.adoreIngredients()) {
          if (ingredient.toLowerCase().contains(pattern.toLowerCase())) {
            shouldInclude = false;
            break;
          }
        }
      } else {
        for (var ingredient in uc.abhorIngredients()) {
          if (ingredient.toLowerCase().contains(pattern.toLowerCase())) {
            shouldInclude = false;
            break;
          }
        }
      }

      if (shouldInclude) {
        if (ingredient.toLowerCase().contains(pattern.toLowerCase())) {
          matches.add(ingredient);
        }
      }
    }

    return matches;
  }
}
