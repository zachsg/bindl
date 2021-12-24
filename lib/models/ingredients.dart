import 'package:bindl/controllers/xcontrollers.dart';
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

  static final allComplete = [
    'Acai Berries',
    'Adobo',
    'Agave',
    'Ahi Tuna',
    'Aka Nori Sushi Seaweed Sheets',
    'Alfredo Sauce',
    'Allspice',
    'All Purpose Flour',
    'Almond Butter',
    'Almond Flour',
    'Almond Meal',
    'Almond Milk',
    'Almonds',
    'Apple Cider Vinegar',
    'Apples',
    'Apricots',
    'Artichoke Hearts',
    'Arugula',
    'Asparagus',
    'Avocado Oil',
    'Avocado',
    'Bacon',
    'Baking Powder',
    'Baking Soda',
    'Balsamic Vinegar',
    'Bamboo',
    'Bananas',
    'Barbecue Sauce',
    'Barley',
    'Basil',
    'Bass',
    'Bay Leaves',
    'BBQ Sauce',
    'Bean Sprouts',
    'Beef Bouillon',
    'Beef Broth',
    'Beef Stock',
    'Beef',
    'Beets',
    'Bell Pepper',
    'Biscuit',
    'Black Beans',
    'Black Cherries',
    'Black Olives',
    'Black Pepper',
    'Blackberries',
    'Blue Cheese',
    'Blueberries',
    'Blueberry Jam',
    'Bok Choy',
    'Bone Broth',
    'Boneless Skinless Chicken',
    'Bread',
    'Broccoli',
    'Brown Rice',
    'Brown Sugar',
    'Brussels Sprouts',
    'Butter',
    'Butternut Squash',
    'Button Mushrooms',
    'Cabbage',
    'Cajun Seasoning',
    'Cane Sugar',
    'Cannellini Beans',
    'Canola Oil',
    'Cantaloupe',
    'Cardamom',
    'Carrots',
    'Cashew Butter',
    'Cashews',
    'Cassava Flour',
    'Catfish',
    'Cauliflower',
    'Cayenne Pepper',
    'Celery',
    'Celery Seeds',
    'Cheddar Cheese',
    'Cherries',
    'Cherry Tomatoes',
    'Chicken Breast',
    'Chicken Broth',
    'Chicken Stock',
    'Chicken',
    'Chickpeas',
    'Chili Flakes',
    'Chili Powder',
    'Chipotle Pepper',
    'Chives',
    'Cilantro',
    'Cinnamon',
    'Coconut Flour',
    'Coconut Milk',
    'Coconut Oil',
    'Coconut',
    'Cod',
    'Colby Jack Cheese',
    'Coleslaw',
    'Collard Greens',
    'Confectioner Sugar',
    'Coriander',
    'Coriander Seeds',
    'Coriander Powder',
    'Corn Tortilla Chips',
    'Corn',
    'Corned Beef',
    'Cottage Cheese',
    'Crab',
    'Cranberries',
    'Crawfish',
    'Cream Cheese',
    'Cremini Mushrooms',
    'Cucumber',
    'Cumin',
    'Dates',
    'Deli Meat',
    'Dill',
    'Dill Relish',
    'Egg Beaters',
    'Egg Noodles',
    'Egg Whites',
    'Egg Yolks',
    'Eggplant',
    'Egg',
    'Evaporated Milk',
    'Extra-Virgin Olive Oil',
    'Farro',
    'Fennel',
    'Fennel',
    'Feta Cheese',
    'Figs',
    'Fingerling Potatoes',
    'Fish Broth',
    'Fish Sauce',
    'Fish',
    'Flaxseed',
    'Flour Tortilla',
    'Garbanzo Beans',
    'Garlic Clove',
    'Garlic Powder',
    'Ginger Root',
    'Ginger Powder',
    'Gojuchang',
    'Gouda Cheese',
    'Grapefruits',
    'Grapes',
    'Grapeseed Oil',
    'Green Beans',
    'Green Chiles',
    'Green Olives',
    'Green Onion',
    'Grits',
    'Ground Beef',
    'Guacamole',
    'Half & Half',
    'Ham',
    'Hamburger Bun',
    'Hash Browns',
    'Heavy Cream',
    'Heirloom Tomatoes',
    'Hoisin Sauce',
    'Honey',
    'Honeydew',
    'Hot Peppers',
    'Hot Sauce',
    'Hot Sauce',
    'Hummus',
    'Iceberg Lettuce',
    'Instant Rice',
    'Italian Tomatoes',
    'Jalapeno',
    'Kalamata Olives',
    'Kale',
    'Ketchup',
    'Key Lime',
    'Kidney Beans',
    'Kimchi',
    'Kiwis',
    'Kumquats',
    'Lasagna Pasta',
    'Lavender',
    'Leeks',
    'Lemongrass',
    'Lemon',
    'Lentils',
    'Lima Beans',
    'Lime',
    'Liquid Eggs',
    'Lobster',
    'Lychee',
    'Macaroni',
    'Maitake Mushrooms',
    'Mandarins',
    'Maple Syrup',
    'Margarine',
    'Marjoram',
    'Marmalade',
    'Mayonnaise',
    'Mexican Blend Cheese',
    'Milk',
    'Miracle Whip',
    'Mirin',
    'Miso',
    'Monterey Jack Cheese',
    'Mozzarella Cheese',
    'Mushrooms',
    'Mustard',
    'Nutmeg',
    'Oat Milk',
    'Oats',
    'Okra',
    'Olive Oil',
    'Olives',
    'Onion',
    'Oranges',
    'Oregano',
    'Orzo Pasta',
    'Oxtail',
    'Oyster Sauce',
    'Panko',
    'Paprika',
    'Parmesan Cheese',
    'Parsley',
    'Passion Fruit',
    'Pasta Sauce',
    'Pasta',
    'Peaches',
    'Peanut Butter',
    'Peanuts',
    'Pears',
    'Peas',
    'Pecans',
    'Pepperjack Cheese',
    'Pesto',
    'Pickle',
    'Pine Nuts',
    'Pineapple',
    'Pinto Beans',
    'Pistachios',
    'Plantains',
    'Plums',
    'Pomegranates',
    'Porcini Mushrooms',
    'Pork',
    'Portobello Mushrooms',
    'Potato Chips',
    'Powdered Sugar',
    'Prawns',
    'Provolone Cheese',
    'Prunes',
    'Pumpkin',
    'Queso Fresca',
    'Quinoa',
    'Radishes',
    'Raisins',
    'Ramen Noodles',
    'Rand Dressing',
    'Raspberries',
    'Raspberry Jam',
    'Ravioli Pasta',
    'Red Cabbage',
    'Red Kidney Beans',
    'Red Onion',
    'Red Pepper',
    'Red Pepper Flakes',
    'Red Wine Vinegar',
    'Red Wine',
    'Ribs',
    'Rice Noodles',
    'Rice Wine Vinegar',
    'Ricotta Cheese',
    'Rockfish',
    'Roma Tomatoes',
    'Romaine Lettuce',
    'Rosemary',
    'Rye Bread',
    'Sage',
    'Salmon',
    'Salsa',
    'Salt',
    'Salted Butter',
    'Sauerkraut',
    'Sausage Links',
    'Sausage Patties',
    'Scallions',
    'Scallops',
    'Seasoned Salt',
    'Sesame Oil',
    'Sesame Seeds',
    'Shallot',
    'Shell Pasta',
    'Sherry Wine',
    'Shiitake Mushrooms',
    'Shrimp',
    'Sirloin Steak',
    'Smoked Ham',
    'Smoked Paprika',
    'Snow Peas',
    'Sour Cream',
    'Soy Milk',
    'Soy Sauce',
    'Spaghetti',
    'Spinach',
    'Spring Mix',
    'Sriracha',
    'Steak Seasoning',
    'Strawberries',
    'Strawberry Jam',
    'Sugar',
    'Sunflower Seeds',
    'Sushi Rice',
    'Sweet Onion',
    'Sweet Potatoes',
    'Seet Red Pepper',
    'Sweet Relish',
    'Swiss Cheese',
    'Swordfish',
    'Tahini',
    'Tamari',
    'Tangerines',
    'Tarragon',
    'Tartar Sauce',
    'Thousand Island Dressing',
    'Thyme',
    'Tilapia',
    'Tobasco',
    'Tofu Eggs',
    'Tofu',
    'Tomato Paste',
    'Tomato Sauce',
    'Tomato',
    'Tortillas',
    'Trout',
    'Turkey',
    'Turmeric',
    'Tuna',
    'Turnips',
    'Unsalted Butter',
    'Vegetable Oil',
    'Velveeta Cheese',
    'Venison',
    'Walnuts',
    'Water',
    'Watercress',
    'Watermelon',
    'Wheat Flour',
    'Wheat Tortilla Chips',
    'White Bread',
    'White Onion',
    'White Onion Powder',
    'White Pepper',
    'White Potatoes',
    'White Rice',
    'White Sugar',
    'White Wine Vinegar',
    'White Wine',
    'Whole Grain Wrap',
    'Whole Star Anise',
    'Whole Wheat Bread',
    'Wild Mushrooms',
    'Worcestershire Sauce',
    'Yams',
    'Yellow Onion',
    'Yellow Mustard',
    'Yellow Squash',
    'Ziti',
    'Zucchini',
  ];

  static final all = List<String>.from(allComplete);
}
