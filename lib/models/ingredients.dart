import 'package:bodai/controllers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Ingredients {
  static List<String> getSuggestions(
      {required WidgetRef ref,
      required String pattern,
      bool useFullList = false}) {
    var matches = <String>[];
    var up = ref.watch(userProvider);

    var adoreAndAbhorIngredients = up.adoreIngredients + up.abhorIngredients;

    if (!useFullList) {
      all.removeWhere((element) => adoreAndAbhorIngredients.contains(element));
      all.removeWhere((element) => element.contains(','));
      all.removeWhere((element) => element.contains('(optional)'));

      for (var ingredient in all) {
        if (ingredient.toLowerCase().contains(pattern.toLowerCase())) {
          matches.add(ingredient);
        }
      }
    } else {
      for (var ingredient in allComplete) {
        if (ingredient.toLowerCase().contains(pattern.toLowerCase())) {
          matches.add(ingredient);
        }
      }
    }

    return matches;
  }

  static final allComplete = oilsFats +
      eggsDairy +
      meatFish +
      vegetables +
      fruits +
      condimentsSauces +
      grains +
      nutsSeedsBeans +
      spices +
      sweeteners +
      misc;

  static final all = List<String>.from(allComplete);

  static final oilsFats = [
    'Avocado Oil',
    'Canola Oil',
    'Coconut Oil',
    'Extra-Virgin Olive Oil',
    'Grapeseed Oil',
    'Olive Oil',
    'Sesame Oil',
    'Vegetable Oil',
  ];

  static final eggsDairy = [
    'Almond Milk',
    'Blue Cheese',
    'Butter',
    'Cheddar Cheese',
    'Coconut Milk',
    'Colby Jack Cheese',
    'Cottage Cheese',
    'Cream Cheese',
    'Crème fraiche',
    'Egg Beaters',
    'Egg Whites',
    'Egg Yolks',
    'Egg',
    'Evaporated Milk',
    'Feta Cheese',
    'Gouda Cheese',
    'Half & Half',
    'Heavy Cream',
    'Liquid Eggs',
    'Margarine',
    'Mexican Blend Cheese',
    'Milk',
    'Monterey Jack Cheese',
    'Mozzarella Cheese',
    'Oat Milk',
    'Parmesan Cheese',
    'Pepperjack Cheese',
    'Provolone Cheese',
    'Queso Fresca',
    'Ricotta Cheese',
    'Romano Cheese',
    'Salted Butter',
    'Sour Cream',
    'Soy Milk',
    'Swiss Cheese',
    'Tofu Eggs',
    'Unsalted Butter',
    'Velveeta Cheese',
  ];

  static final meatFish = [
    'Ahi Tuna',
    'Bacon',
    'Bass',
    'Beef Bouillon',
    'Beef Broth',
    'Beef Stock',
    'Beef',
    'Bone Broth',
    'Boneless Skinless Chicken',
    'Catfish',
    'Chicken',
    'Chicken Breast',
    'Chicken Broth',
    'Chicken Stock',
    'Cod',
    'Corned Beef',
    'Crab Legs',
    'Crabmeat',
    'Crawfish',
    'Deli Meat',
    'Fish',
    'Fish Broth',
    'Ground Beef',
    'Ham',
    'Lobster',
    'Oxtail',
    'Pork',
    'Prawns',
    'Ribs',
    'Rockfish',
    'Salmon',
    'Sausage',
    'Sausage Links',
    'Sausage Patties',
    'Scallops',
    'Shrimp',
    'Sirloin Steak',
    'Smoked Ham',
    'Swordfish',
    'Tilapia',
    'Trout',
    'Turkey',
    'Tuna',
    'Venison',
  ];

  static final vegetables = [
    'Aka Nori Sushi Seaweed Sheets',
    'Chipotle Pepper',
    'Chives',
    'Dried Cilantro',
    'Fresh Cilantro',
    'Cilantro',
    'Artichoke Hearts',
    'Arugula',
    'Asparagus',
    'Bamboo',
    'Bean Sprouts',
    'Beets',
    'Bell Pepper',
    'Bok Choy',
    'Broccoli',
    'Brussels Sprouts',
    'Butternut Squash',
    'Button Mushrooms',
    'Cabbage',
    'Carrots',
    'Head Cauliflower',
    'Cauliflower',
    'Celery',
    'Collard Greens',
    'Corn',
    'Cremini Mushrooms',
    'Cucumber',
    'Eggplant',
    'Fingerling Potatoes',
    'Green Beans',
    'Green Chiles',
    'Green Onion',
    'Hash Browns',
    'Hot Peppers',
    'Iceberg Lettuce',
    'Jalapeno',
    'Kale',
    'Leeks',
    'Lemongrass',
    'Maitake Mushrooms',
    'Mushrooms',
    'Onion',
    'Okra',
    'Dried Parsley',
    'Fresh Parsley',
    'Parsley',
    'Peas',
    'Pickle',
    'Plantains',
    'Porcini Mushrooms',
    'Portobello Mushrooms',
    'Pumpkin',
    'Radishes',
    'Red Cabbage',
    'Red Onion',
    'Red Pepper',
    'Romaine Lettuce',
    'Scallions',
    'Shallot',
    'Shiitake Mushrooms',
    'Snow Peas',
    'Spinach',
    'Spring Mix',
    'Sweet Onion',
    'Sweet Potatoes',
    'Sweet Red Pepper',
    'Turmeric',
    'Turnips',
    'Watercress',
    'White Onion',
    'White Pepper',
    'White Potatoes',
    'Wild Mushrooms',
    'Yellow Onion',
    'Yams',
    'Yellow Squash',
    'Ziti',
    'Zucchini',
  ];

  static final fruits = [
    'Acai Berries',
    'Apples',
    'Apricots',
    'Avocado',
    'Bananas',
    'Black Cherries',
    'Black Olives',
    'Blackberries',
    'Blueberries',
    'Cantaloupe',
    'Cherries',
    'Cherry Tomatoes',
    'Cranberries',
    'Dates',
    'Figs',
    'Grapefruits',
    'Grapes',
    'Grape Tomatoes',
    'Green Olives',
    'Heirloom Tomatoes',
    'Honeydew',
    'Italian Tomatoes',
    'Kalamata Olives',
    'Key Lime',
    'Kiwis',
    'Kumquats',
    'Lemon',
    'Lemon Juice',
    'Lime',
    'Lime Juice',
    'Lychee',
    'Mandarins',
    'Oranges',
    'Olives',
    'Passion Fruit',
    'Peaches',
    'Pears',
    'Pineapple',
    'Plums',
    'Pomegranates',
    'Prunes',
    'Raisins',
    'Raspberries',
    'Roma Tomatoes',
    'Strawberries',
    'Tangerines',
    'Tomato',
    'Watermelon',
  ];

  static final condimentsSauces = [
    'Adobo',
    'Apple Cider Vinegar',
    'Alfredo Sauce',
    'Balsamic Vinegar',
    'BBQ Sauce',
    'Barbecue Sauce',
    'Blueberry Jam',
    'Coleslaw',
    'Dill Relish',
    'Fish Sauce',
    'Gojuchang',
    'Guacamole',
    'Hoisin Sauce',
    'Hot Sauce',
    'Lasagna Pasta',
    'Hot Sauce',
    'Hummus',
    'Italian Salad Dressing',
    'Ketchup',
    'Kimchi',
    'Marmalade',
    'Mayonnaise',
    'Miracle Whip',
    'Mirin',
    'Miso',
    'Mustard',
    'Oyster Sauce',
    'Pasta Sauce',
    'Pesto',
    'Ranch Dressing',
    'Raspberry Jam',
    'Red Wine Vinegar',
    'Red Wine',
    'Rice Wine Vinegar',
    'Salsa',
    'Sauerkraut',
    'Sherry Wine',
    'Soy Sauce',
    'Sriracha',
    'Strawberry Jam',
    'Sweet Relish',
    'Tahini',
    'Tamari',
    'Tartar Sauce',
    'Thousand Island Dressing',
    'Tobasco',
    'Tomato Paste',
    'Tomato Sauce',
    'White Wine Vinegar',
    'White Wine',
    'Yellow Mustard',
    'Worcestershire Sauce',
  ];

  static final grains = [
    'All Purpose Flour',
    'Almond Flour',
    'Almond Meal',
    'Barley',
    'Baking Powder',
    'Baking Soda',
    'Biscuit',
    'Bread',
    'Bread Crumbs',
    'Italian-Seasoned Bread Crumbs',
    'Brown Rice',
    'Butter Round Crackers',
    'Cassava Flour',
    'Cavatappi pasta',
    'Coconut Flour',
    'Corn Tortilla Chips',
    'Egg Noodles',
    'Farro',
    'Flour Tortilla',
    'Grits',
    'Hamburger Bun',
    'Instant Rice',
    'Macaroni',
    'Oats',
    'Orzo Pasta',
    'Panko',
    'Pasta',
    'Potato Chips',
    'Quinoa',
    'Ramen Noodles',
    'Ravioli Pasta',
    'Rice Noodles',
    'Rye Bread',
    'Shell Pasta',
    'Spaghetti',
    'Sushi Rice',
    'Tortillas',
    'Wheat Flour',
    'Wheat Tortilla Chips',
    'White Bread',
    'White Rice',
    'Whole Wheat Bread',
    'Whole Grain Wrap',
  ];

  static final nutsSeedsBeans = [
    'Almond Butter',
    'Almonds',
    'Black Beans',
    'Cannellini Beans',
    'Cashew Butter',
    'Cashews',
    'Chickpeas',
    'Coconut',
    'Flaxseed',
    'Garbanzo Beans',
    'Kidney Beans',
    'Lentils',
    'Lima Beans',
    'Peanut Butter',
    'Peanuts',
    'Pecans',
    'Pine Nuts',
    'Pinto Beans',
    'Pistachios',
    'Red Kidney Beans',
    'Sesame Seeds',
    'Sunflower Seeds',
    'Tofu',
    'Walnuts',
  ];

  static final spices = [
    'Allspice',
    'Dried Basil',
    'Fresh Basil',
    'Basil',
    'Bay Leaves',
    'Black Pepper',
    'Cajun Seasoning',
    'Cardamom',
    'Cayenne Pepper',
    'Celery Seeds',
    'Chili Flakes',
    'Chili Powder',
    'Cinnamon',
    'Coriander',
    'Coriander Seeds',
    'Coriander Powder',
    'Cumin',
    'Dried Dill',
    'Fresh Dill',
    'Dill',
    'Fennel',
    'Garlic Clove',
    'Garlic Powder',
    'Ginger Root',
    'Ginger Powder',
    'Lavender',
    'Dried Marjoram',
    'Fresh Marjoram',
    'Marjoram',
    'Nutmeg',
    'Onion Powder',
    'Dried Oregano',
    'Fresh Oregano',
    'Oregano',
    'Paprika',
    'Red Pepper Flakes',
    'Dried Rosemary',
    'Fresh Rosemary',
    'Rosemary',
    'Sage',
    'Salt',
    'Seasoned Salt',
    'Smoked Paprika',
    'Steak Seasoning',
    'Sweet Paprika',
    'Tarragon',
    'Thyme',
    'White Onion Powder',
    'Whole Star Anise',
  ];

  static final sweeteners = [
    'Agave',
    'Brown Sugar',
    'Cane Sugar',
    'Confectioner Sugar',
    'Honey',
    'Maple Syrup',
    'Powdered Sugar',
    'Sugar',
    'White Sugar',
  ];

  static final misc = [
    'Water',
  ];
}
