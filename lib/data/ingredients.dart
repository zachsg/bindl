import 'package:bodai/features/pantry/pantry_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/ingredient.dart';
import '../models/ingredient_category.dart';

class Ingredients {
  static List<String> getSuggestions(String pattern, WidgetRef ref) {
    final alreadyUsed = [];

    for (final i in ref.watch(pantryProvider)) {
      alreadyUsed.add(i.ingredient.name);
    }

    final tempAllString =
        allString().where((element) => !alreadyUsed.contains(element));

    return tempAllString
        .where((element) =>
            element.contains(pattern.toLowerCase()) &&
            !alreadyUsed.contains(pattern))
        .toList();
  }

  static List<String> getSuggestionsRecipe(String pattern, WidgetRef ref) {
    return allString()
        .where((element) => element.contains(pattern.toLowerCase()))
        .toList();
  }

  static List<String> allString() {
    List<String> ingredientStrings = [];
    for (final i in all) {
      ingredientStrings.add(i.name);
    }

    return ingredientStrings;
  }

  static double gramsPerIngredientFor(Ingredient ingredient) {
    switch (ingredient.name.toLowerCase()) {
      case 'garlic cloves':
      case 'garlic clove':
        return 5.0;
      case 'cauliflower':
      case 'cauliflowers':
      case 'cauliflower head':
        return 840.0;
      case 'sage leaf':
      case 'sage leaves':
        return 1.0;
      case 'bell pepper':
      case 'bell peppers':
        return 150.0;
      case 'scallion':
      case 'scallions':
      case 'green onion':
      case 'green onions':
        return 11.0;
      case 'shallot':
      case 'shallots':
        return 36.0;
      case 'zucchini':
      case 'zucchinis':
        return 200.0;
      case 'egg':
      case 'eggs':
        return 50.0;
      case 'cucumber':
      case 'cucumbers':
        return 340.0;
      case 'onion':
      case 'onions':
      case 'red onion':
      case 'red onions':
      case 'white onion':
      case 'white onions':
      case 'yellow onion':
      case 'yellow onions':
        return 160.0;
      case 'sweet potato':
      case 'sweet potatoes':
      case 'japanese sweet potato':
      case 'japanese sweet potatoes':
        return 130.0;
      case 'potato':
      case 'potatoes':
      case 'white potato':
      case 'white potatoes':
        return 170.0;
      case 'red chilli':
      case 'red chillis':
        return 25.0;
      case 'romaine lettuce':
        return 28.0;
      case 'avocado':
      case 'avocados':
        return 170.0;
      case 'lemon':
      case 'lemons':
        return 58.0;
      case 'lime':
      case 'limes':
        return 67.0;
      case 'cabbage':
      case 'cabbages':
      case 'red cabbage':
      case 'red cabbages':
        return 1106.0;
      case 'carrot':
      case 'carrots':
        return 75.0;
      case 'baby bok choy':
        return 113.0;
      case 'bok choy':
        return 840.0;
      case 'bacon':
      case 'bacon slice':
      case 'bacons slices':
        return 15.0;
      case 'flour tortilla':
      case 'flour tortillas':
        return 65.0;
      case 'corn tortilla':
      case 'corn tortillas':
        return 35.0;
      case 'pineapple':
      case 'pineapples':
        return 905.0;
      case 'steak':
      case 'steaks':
      case 'beef loin steak':
      case 'beef loin steaks':
      case 'sirloin steak':
      case 'sirloin steaks':
      case 'top loin steak':
      case 'top loin steaks':
      case 'new york steak':
      case 'new york steaks':
      case 'new york strip steak':
      case 'new york strip steaks':
      case 'ambassador steak':
      case 'ambassador steaks':
      case 'boneless club steak':
      case 'boneless club steaks':
        return 230.0;
      default:
        return 1.0;
    }
  }

  /// NEXT AVAILABLE ID: 471

  static List<Ingredient> all = const [
    /// OILS
    Ingredient(
      id: 0,
      name: 'avocado oil',
      category: IngredientCategory.oils,
    ),
    Ingredient(
      id: 1,
      name: 'canola oil',
      category: IngredientCategory.oils,
    ),
    Ingredient(
      id: 2,
      name: 'coconut oil',
      category: IngredientCategory.oils,
    ),
    Ingredient(
        id: 3,
        name: 'extra-virgin olive oil',
        category: IngredientCategory.oils),
    Ingredient(
      id: 4,
      name: 'olive oil',
      category: IngredientCategory.oils,
    ),
    Ingredient(
      id: 5,
      name: 'grapeseed oil',
      category: IngredientCategory.oils,
    ),
    Ingredient(
      id: 6,
      name: 'sesame oil',
      category: IngredientCategory.oils,
    ),
    Ingredient(
      id: 7,
      name: 'peanut oil',
      category: IngredientCategory.oils,
    ),
    Ingredient(
      id: 8,
      name: 'vegetable oil',
      category: IngredientCategory.oils,
    ),

    /// EGGS
    Ingredient(
      id: 9,
      name: 'egg',
      category: IngredientCategory.eggs,
    ),
    Ingredient(
      id: 10,
      name: 'egg white',
      category: IngredientCategory.eggs,
    ),
    Ingredient(
      id: 11,
      name: 'egg yolk',
      category: IngredientCategory.eggs,
    ),
    Ingredient(
      id: 12,
      name: 'egg beater',
      category: IngredientCategory.eggs,
    ),

    /// DAIRY ALTERNATIVES
    Ingredient(
      id: 13,
      name: 'almond milk',
      category: IngredientCategory.dairyAlternative,
    ),
    Ingredient(
      id: 14,
      name: 'coconut milk',
      category: IngredientCategory.dairyAlternative,
    ),
    Ingredient(
      id: 15,
      name: 'cashew milk',
      category: IngredientCategory.dairyAlternative,
    ),
    Ingredient(
      id: 16,
      name: 'oat milk',
      category: IngredientCategory.dairyAlternative,
    ),
    Ingredient(
      id: 17,
      name: 'soy milk',
      category: IngredientCategory.dairyAlternative,
    ),
    Ingredient(
      id: 18,
      name: 'margarine',
      category: IngredientCategory.dairyAlternative,
    ),
    Ingredient(
      id: 453,
      name: 'vegan cheese',
      category: IngredientCategory.dairyAlternative,
    ),

    /// DAIRY
    Ingredient(
      id: 19,
      name: 'salted butter',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 20,
      name: 'unsalted butter',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 21,
      name: 'cheddar cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 22,
      name: 'blue cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 23,
      name: 'colby jack cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 24,
      name: 'feta cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 25,
      name: 'gouda cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 466,
      name: 'smoked gouda cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 26,
      name: 'mexican blend cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 468,
      name: 'shredded cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 27,
      name: 'monterey jack cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 28,
      name: 'parmesan cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 29,
      name: 'pepperjack cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 30,
      name: 'provolone cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 31,
      name: 'romano cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 32,
      name: 'swiss cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 33,
      name: 'velveeta cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 34,
      name: 'cottage cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 35,
      name: 'cream cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 36,
      name: 'crème fraiche',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 37,
      name: 'half & half',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 38,
      name: 'heavy cream',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 39,
      name: 'evaporated milk',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 40,
      name: 'whole milk',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 41,
      name: 'reduced fat milk',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 42,
      name: 'skim milk',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 43,
      name: 'queso fresca',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 44,
      name: 'sour cream',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 419,
      name: 'brie cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 422,
      name: 'full fat yogurt',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 423,
      name: 'fat-free yogurt',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 424,
      name: 'greek yogurt',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 426,
      name: 'ghee',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 427,
      name: 'mozzarella cheese',
      category: IngredientCategory.dairy,
    ),
    Ingredient(
      id: 432,
      name: 'asiago cheese',
      category: IngredientCategory.dairy,
    ),

    /// MEAT
    Ingredient(
      id: 45,
      name: 'beef bouillon',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 46,
      name: 'beef broth',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 47,
      name: 'beef stock',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 48,
      name: 'beef bone broth',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 49,
      name: 'bacon',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 50,
      name: 'ground beef',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 51,
      name: 'corned beef',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 52,
      name: 'oxtail',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 53,
      name: 'ribeye',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 54,
      name: 'filet mignon',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 55,
      name: 'beef rib',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 56,
      name: 'flank steak',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 57,
      name: 'chuck roast',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 58,
      name: 'sirloin steak',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 59,
      name: 'boneless skinless chicken',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 60,
      name: 'chicken drumbstick',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 61,
      name: 'chicken breast',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 62,
      name: 'chicken thigh',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 63,
      name: 'chicken wing',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 64,
      name: 'chicken broth',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 65,
      name: 'chicken stock',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 66,
      name: 'chicken bone broth',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 67,
      name: 'deli chicken',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 68,
      name: 'deli ham',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 69,
      name: 'deli roast beef',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 70,
      name: 'deli turkey',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 71,
      name: 'ham',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 72,
      name: 'turkey leg',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 73,
      name: 'turkey breast',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 74,
      name: 'turkey thigh',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 75,
      name: 'venison',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 76,
      name: 'lamb chop',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 77,
      name: 'pork butt',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 78,
      name: 'pork chop',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 79,
      name: 'ground turkey',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 80,
      name: 'turkey sausage',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 81,
      name: 'pork sausage',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 82,
      name: 'beef hotdog',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 83,
      name: 'pork hotdog',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 428,
      name: 'pepperoni',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 431,
      name: 'pork shoulder',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 441,
      name: 'beef loin steak',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 442,
      name: 'prosciutto',
      category: IngredientCategory.meat,
    ),
    Ingredient(
      id: 447,
      name: 'ground bison',
      category: IngredientCategory.meat,
    ),

    /// MEAT ALTERNATIVES
    Ingredient(
      id: 84,
      name: 'plant based sausage',
      category: IngredientCategory.meatAlternative,
    ),
    Ingredient(
      id: 85,
      name: 'tofu',
      category: IngredientCategory.meatAlternative,
    ),
    Ingredient(
      id: 455,
      name: 'tempeh',
      category: IngredientCategory.meatAlternative,
    ),
    Ingredient(
      id: 456,
      name: 'plant based beef',
      category: IngredientCategory.meatAlternative,
    ),
    Ingredient(
      id: 457,
      name: 'plant based chicken',
      category: IngredientCategory.meatAlternative,
    ),
    Ingredient(
      id: 458,
      name: 'plant based burger',
      category: IngredientCategory.meatAlternative,
    ),

    /// FISH
    Ingredient(
      id: 86,
      name: 'ahi tuna',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 462,
      name: 'tuna',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 463,
      name: 'canned tuna',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 87,
      name: 'bass',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 88,
      name: 'catfish',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 89,
      name: 'cod',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 90,
      name: 'crabmeat',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 91,
      name: 'crab legs',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 92,
      name: 'crawfish',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 93,
      name: 'lobster',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 94,
      name: 'fish broth',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 95,
      name: 'prawns',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 96,
      name: 'shrimp',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 97,
      name: 'rockfish',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 98,
      name: 'salmon',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 449,
      name: 'canned salmon',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 99,
      name: 'trout',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 100,
      name: 'scallops',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 101,
      name: 'swordfish',
      category: IngredientCategory.fish,
    ),
    Ingredient(
      id: 102,
      name: 'tilapia',
      category: IngredientCategory.fish,
    ),

    /// VEGETABLES
    Ingredient(
      id: 103,
      name: 'nori sushi seaweed sheet',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 104,
      name: 'chipotle pepper',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 105,
      name: 'chives',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 106,
      name: 'dried cilantro',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 107,
      name: 'fresh cilantro',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 108,
      name: 'artichoke hearts',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 109,
      name: 'artichoke',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 110,
      name: 'arugula',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 111,
      name: 'asparagus',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 112,
      name: 'bamboo',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 113,
      name: 'bean sprouts',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 114,
      name: 'beets',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 115,
      name: 'bell pepper',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 116,
      name: 'bok choy',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 117,
      name: 'baby bok choy',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 118,
      name: 'broccoli',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 119,
      name: 'brussels sprouts',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 120,
      name: 'butternut squash',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 121,
      name: 'button mushrooms',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 122,
      name: 'cremini mushrooms',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 123,
      name: 'maitake mushrooms',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 124,
      name: 'porcini mushrooms',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 125,
      name: 'portobello mushrooms',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 126,
      name: 'shiitake mushrooms',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 127,
      name: 'wild mushrooms',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 128,
      name: 'cabbage',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 129,
      name: 'cauliflower',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 130,
      name: 'celery',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 131,
      name: 'collard greens',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 132,
      name: 'corn (cobb)',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 133,
      name: 'corn (kernels)',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 134,
      name: 'cucumber',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 135,
      name: 'eggplant',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 136,
      name: 'fingerling potatoes',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 137,
      name: 'white potato',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 138,
      name: 'sweet potato',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 139,
      name: 'yam',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 140,
      name: 'japanese sweet potato',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 141,
      name: 'green beans',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 142,
      name: 'green chiles',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 143,
      name: 'green onion',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 144,
      name: 'hash browns',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 145,
      name: 'hot pepper',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 146,
      name: 'jalapeño pepper',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 147,
      name: 'iceberg lettuce',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 148,
      name: 'kale',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 149,
      name: 'leeks',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 150,
      name: 'lemongrass',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 151,
      name: 'white onion',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 152,
      name: 'yellow onion',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 153,
      name: 'red onion',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 154,
      name: 'okra',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 155,
      name: 'dried parsley',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 156,
      name: 'fresh parsley',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 157,
      name: 'snow peas',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 158,
      name: 'peas',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 159,
      name: 'kosher pickle',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 160,
      name: 'manhattan pickle',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 161,
      name: 'dill pickle',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 162,
      name: 'pumpkin',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 163,
      name: 'radishes',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 164,
      name: 'red pepper',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 165,
      name: 'romaine lettuce',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 166,
      name: 'mustard greens',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 167,
      name: 'scallions',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 168,
      name: 'shallots',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 169,
      name: 'spinach',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 170,
      name: 'baby spinach',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 171,
      name: 'spring mix',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 172,
      name: 'carrots',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 173,
      name: 'baby carrots',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 174,
      name: 'sweet onion',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 175,
      name: 'turnips',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 176,
      name: 'vegetable broth',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 177,
      name: 'vegetable stock',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 178,
      name: 'watercress',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 179,
      name: 'yellow squash',
      category: IngredientCategory.vegetables,
    ),
    Ingredient(
      id: 180,
      name: 'zucchini',
      category: IngredientCategory.vegetables,
    ),

    /// FRUIT
    Ingredient(
      id: 181,
      name: 'acai berries',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 182,
      name: 'blueberries',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 183,
      name: 'raspberries',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 184,
      name: 'blackberries',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 185,
      name: 'cranberries',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 186,
      name: 'strawberries',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 187,
      name: 'cherries',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 188,
      name: 'black cherries',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 189,
      name: 'apple',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 190,
      name: 'apricot',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 191,
      name: 'peach',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 192,
      name: 'asian pear',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 193,
      name: 'pear',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 194,
      name: 'plum',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 195,
      name: 'pluot',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 196,
      name: 'banana',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 197,
      name: 'cantaloupe',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 198,
      name: 'honeydew',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 199,
      name: 'watermelon',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 200,
      name: 'dates',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 201,
      name: 'figs',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 202,
      name: 'green grapes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 203,
      name: 'concord grapes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 204,
      name: 'grapes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 205,
      name: 'grapefruit',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 206,
      name: 'orange',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 207,
      name: 'blood orange',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 208,
      name: 'kumquats',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 209,
      name: 'tangerine',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 210,
      name: 'tangelo',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 211,
      name: 'lemon',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 212,
      name: 'lime',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 213,
      name: 'key lime',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 214,
      name: 'mandarin',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 215,
      name: 'clementine',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 216,
      name: 'kiwi',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 217,
      name: 'coconut',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 218,
      name: 'lychee',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 219,
      name: 'peach',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 221,
      name: 'pomegranate',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 222,
      name: 'pomegranate seeds',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 223,
      name: 'prunes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 224,
      name: 'raisins',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 225,
      name: 'avocado',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 226,
      name: 'black olives',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 227,
      name: 'green olives',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 228,
      name: 'kalamata olives',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 229,
      name: 'cherry tomatoes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 230,
      name: 'heirloom tomatoes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 231,
      name: 'italian tomatoes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 232,
      name: 'grape tomatoes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 233,
      name: 'roma tomatoes',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 234,
      name: 'plantain',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 425,
      name: 'orange juice',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 439,
      name: 'pineapple',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 440,
      name: 'lemon juice',
      category: IngredientCategory.fruit,
    ),
    Ingredient(
      id: 443,
      name: 'sun-dried tomatoes',
      category: IngredientCategory.fruit,
    ),

    /// CONDIMENTS
    Ingredient(
      id: 235,
      name: 'apple cider vinegar',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 236,
      name: 'balsamic vinegar',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 237,
      name: 'red wine vinegar',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 238,
      name: 'rice wine vinegar',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 239,
      name: 'white wine vinegar',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 240,
      name: 'red wine',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 241,
      name: 'white wine',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 242,
      name: 'sherry wine',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 243,
      name: 'blueberry jam',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 244,
      name: 'blackberry jam',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 245,
      name: 'raspberry jam',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 246,
      name: 'marmalade',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 247,
      name: 'coleslaw',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 248,
      name: 'dill relish',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 249,
      name: 'sweet relish',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 250,
      name: 'gochujang',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 251,
      name: 'guacamole',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 252,
      name: 'hummus',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 253,
      name: 'tahini',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 254,
      name: 'ketchup',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 255,
      name: 'kimchi',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 256,
      name: 'mayonnaise',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 257,
      name: 'miracle whip',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 258,
      name: 'mirin',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 259,
      name: 'miso',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 260,
      name: 'yellow mustard',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 261,
      name: 'dijon mustard',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 262,
      name: 'spicy mustard',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 263,
      name: 'salsa',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 264,
      name: 'sauerkraut',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 265,
      name: 'sriracha',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 421,
      name: 'horseradish',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 266,
      name: 'tobasco',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 450,
      name: 'cacao nibs',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 451,
      name: 'cocoa (cacao) powder',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 454,
      name: 'nutritional yeast',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 459,
      name: 'protein powder',
      category: IngredientCategory.condiments,
    ),
    Ingredient(
      id: 464,
      name: 'collagen',
      category: IngredientCategory.condiments,
    ),

    /// SAUCES
    Ingredient(
      id: 267,
      name: 'adobo',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 268,
      name: 'bbq sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 269,
      name: 'fish sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 270,
      name: 'hoisin sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 271,
      name: 'hot sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 272,
      name: 'oyster sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 273,
      name: 'tomato sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 274,
      name: 'tomato paste',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 275,
      name: 'alfredo sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 276,
      name: 'pesto',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 277,
      name: 'soy sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 278,
      name: 'tamari',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 279,
      name: 'coconut aminos',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 280,
      name: 'tartar sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 281,
      name: 'worcestershire sauce',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 430,
      name: 'chili paste',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 444,
      name: 'basil pesto',
      category: IngredientCategory.sauces,
    ),
    Ingredient(
      id: 445,
      name: 'sweet and sour sauce',
      category: IngredientCategory.sauces,
    ),

    /// DRESSINGS
    Ingredient(
      id: 282,
      name: 'italian dressing',
      category: IngredientCategory.dressings,
    ),
    Ingredient(
      id: 283,
      name: 'caesar dressing',
      category: IngredientCategory.dressings,
    ),
    Ingredient(
      id: 284,
      name: 'vinaigrette',
      category: IngredientCategory.dressings,
    ),
    Ingredient(
      id: 285,
      name: 'ranch dressing',
      category: IngredientCategory.dressings,
    ),
    Ingredient(
      id: 286,
      name: 'thousand island dressing',
      category: IngredientCategory.dressings,
    ),

    /// GRAINS
    Ingredient(
      id: 287,
      name: 'all purpose flour',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 288,
      name: 'barley',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 289,
      name: 'biscuit',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 290,
      name: 'whole wheat bread',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 291,
      name: 'multigrain bread',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 292,
      name: 'white bread',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 293,
      name: 'italian bread crumbs',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 294,
      name: 'bread crumbs',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 295,
      name: 'brown rice',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 296,
      name: 'jasmine rice',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 297,
      name: 'sushi rice',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 298,
      name: 'butter round crackers',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 299,
      name: 'farro',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 300,
      name: 'flour tortillas',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 301,
      name: 'hamburger buns',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 302,
      name: 'instant rice',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 303,
      name: 'panko',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 304,
      name: 'rye bread',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 305,
      name: 'sourdough bread',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 306,
      name: 'flour tortilla chips',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 307,
      name: 'whole grain wrap',
      category: IngredientCategory.grains,
    ),
    Ingredient(
      id: 460,
      name: 'taco shells',
      category: IngredientCategory.grains,
    ),

    /// GRAIN ALTERNATIVES
    Ingredient(
      id: 308,
      name: 'almond flour',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 309,
      name: 'almond meal',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 310,
      name: 'baking powder',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 311,
      name: 'baking soda',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 312,
      name: 'casava flour',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 313,
      name: 'coconut flour',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 314,
      name: 'corn tortilla chips',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 315,
      name: 'grits',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 316,
      name: 'oats',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 317,
      name: 'potato chips',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 318,
      name: 'quinoa',
      category: IngredientCategory.grainAlernatives,
    ),
    Ingredient(
      id: 420,
      name: 'psyllium husk powder',
      category: IngredientCategory.grainAlernatives,
    ),

    /// PASTA
    Ingredient(
      id: 319,
      name: 'cavatappi pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 320,
      name: 'lasagna pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 321,
      name: 'macaroni pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 322,
      name: 'orzo pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 323,
      name: 'ravioli pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 465,
      name: 'mushroom ravioli pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 324,
      name: 'shell pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 325,
      name: 'spaghetti pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 326,
      name: 'ziti pasta',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 327,
      name: 'egg noodles',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 328,
      name: 'ramen noodles',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 329,
      name: 'rice noodles',
      category: IngredientCategory.pasta,
    ),
    Ingredient(
      id: 469,
      name: 'gnocchi pasta',
      category: IngredientCategory.pasta,
    ),

    /// NUTS
    Ingredient(
      id: 330,
      name: 'almond butter',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 331,
      name: 'almonds',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 332,
      name: 'cashew butter',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 332,
      name: 'cashews',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 334,
      name: 'walnuts',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 335,
      name: 'tigernuts',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 336,
      name: 'pecans',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 337,
      name: 'poistachios',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 338,
      name: 'pine nuts',
      category: IngredientCategory.nuts,
    ),
    Ingredient(
      id: 339,
      name: 'brazil nuts',
      category: IngredientCategory.nuts,
    ),

    /// SEEDS
    Ingredient(
      id: 340,
      name: 'flaxseed',
      category: IngredientCategory.seeds,
    ),
    Ingredient(
      id: 341,
      name: 'chia seeds',
      category: IngredientCategory.seeds,
    ),
    Ingredient(
      id: 342,
      name: 'sunflower seeds',
      category: IngredientCategory.seeds,
    ),
    Ingredient(
      id: 343,
      name: 'sesame seeds',
      category: IngredientCategory.seeds,
    ),
    Ingredient(
      id: 344,
      name: 'poppy seeds',
      category: IngredientCategory.seeds,
    ),

    /// BEANS
    Ingredient(
      id: 345,
      name: 'peanut butter',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 346,
      name: 'peanuts',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 347,
      name: 'cannellini beans',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 348,
      name: 'garbanzo beans (chickpeas)',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 349,
      name: 'kidney beans',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 350,
      name: 'lentils',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 351,
      name: 'lima beans',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 352,
      name: 'navy beans',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 353,
      name: 'pinto beans',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 354,
      name: 'black beans',
      category: IngredientCategory.beans,
    ),
    Ingredient(
      id: 355,
      name: 'refried beans',
      category: IngredientCategory.beans,
    ),

    /// SPICES
    Ingredient(
      id: 356,
      name: 'allspice',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 357,
      name: 'dried basil',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 358,
      name: 'fresh basil',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 359,
      name: 'bay leaf',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 360,
      name: 'black pepper',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 467,
      name: 'white pepper',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 361,
      name: 'cajun seasoning',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 362,
      name: 'cardamom',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 363,
      name: 'tumeric (turmeric) powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 364,
      name: 'tumeric (turmeric) root',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 365,
      name: 'cayenne pepper',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 366,
      name: 'celery seeds',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 367,
      name: 'chili flakes',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 368,
      name: 'chili powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 470,
      name: 'red chili',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 369,
      name: 'cinnamon stick',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 370,
      name: 'cinnamon powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 371,
      name: 'coriander seeds',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 372,
      name: 'coriander powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 373,
      name: 'cumin seeds',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 448,
      name: 'cumin powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 374,
      name: 'dried dill',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 375,
      name: 'fresh dill',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 376,
      name: 'fennel',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 377,
      name: 'garlic clove',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 378,
      name: 'garlic powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 379,
      name: 'ginger root',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 380,
      name: 'ginger powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 381,
      name: 'lavender',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 382,
      name: 'dried marjoram',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 383,
      name: 'fresh marjoram',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 384,
      name: 'nutmeg',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 385,
      name: 'onion powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 386,
      name: 'dried oregano',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 387,
      name: 'fresh oregano',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 388,
      name: 'paprika',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 389,
      name: 'sweet paprika',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 390,
      name: 'smoked paprika',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 391,
      name: 'red pepper flakes',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 392,
      name: 'dried rosemary',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 393,
      name: 'fresh rosemary',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 394,
      name: 'dried sage',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 395,
      name: 'fresh sage',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 396,
      name: 'salt',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 397,
      name: 'seasoned salt',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 398,
      name: 'steak seasoning',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 399,
      name: 'tarragon',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 400,
      name: 'dried thyme',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 401,
      name: 'fresh thyme',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 402,
      name: 'whole star anise',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 403,
      name: 'saffron',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 429,
      name: 'italian seasoning',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 433,
      name: 'onion salt',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 434,
      name: 'garlic salt',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 435,
      name: 'sea salt',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 436,
      name: 'mustard powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 437,
      name: 'yeast',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 438,
      name: 'sage leaves',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 452,
      name: 'curry powder',
      category: IngredientCategory.spices,
    ),
    Ingredient(
      id: 461,
      name: 'taco seasoning',
      category: IngredientCategory.spices,
    ),

    /// SWEETENERS
    Ingredient(
      id: 404,
      name: 'agave',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 405,
      name: 'brown sugar',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 406,
      name: 'cane sugar',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 407,
      name: 'white sugar',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 408,
      name: 'confectioner sugar',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 409,
      name: 'powdered sugar',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 410,
      name: 'honey',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 411,
      name: 'maple syrup',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 412,
      name: 'molasses',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 413,
      name: 'monk fruit',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 414,
      name: 'stevia',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 415,
      name: 'xylitol',
      category: IngredientCategory.sweeteners,
    ),
    Ingredient(
      id: 416,
      name: 'erythritol',
      category: IngredientCategory.sweeteners,
    ),

    /// MISC
    Ingredient(
      id: 417,
      name: 'tap water',
      category: IngredientCategory.misc,
    ),
    Ingredient(
      id: 418,
      name: 'distilled water',
      category: IngredientCategory.misc,
    ),
    Ingredient(
      id: 446,
      name: 'water',
      category: IngredientCategory.misc,
    ),
  ];
}
