import 'package:bindl/shared/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Ingredients {
  static List<String> getSuggestions(
      WidgetRef ref, String pattern, bool isAdore) {
    var matches = <String>[];
    var uc = ref.read(userProvider);

    var adoreAndAbhorIngredients =
        uc.adoreIngredients() + uc.abhorIngredients();

    all.removeWhere((element) => adoreAndAbhorIngredients.contains(element));

    for (var ingredient in all) {
      if (ingredient.toLowerCase().contains(pattern.toLowerCase())) {
        matches.add(ingredient);
      }
    }

    return matches;
  }

  static final all = [
    'Acai Berries',
    'Agave',
    'Alfredo Sauce',
    'Allspice',
    'Almond Butter',
    'Almond Flour',
    'Almond Milk',
    'Almonds',
    'Apple Cider Vinegar',
    'Apples',
    'Apricots',
    'Artichoke Hearts',
    'Arugula',
    'Asparagus',
    'Avocado Oil',
    'Avocados',
    'Bacon',
    'Baking Powder',
    'Balsamic Vinegar',
    'Bamboo',
    'Bananas',
    'Barbecue Sauce',
    'Barley',
    'Basil',
    'Bass',
    'Bay Leaves',
    'Bean Sprouts',
    'Beef Broth',
    'Beef Stock',
    'Beef',
    'Beets',
    'Bell Peppers',
    'Biscuits',
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
    'Bread',
    'Broccoli',
    'Brown Rice',
    'Brown Sugar',
    'Brussels Sprouts',
    'Butter',
    'Butternut Squash',
    'Button Mushrooms',
    'Cane Sugar',
    'Canola Oil',
    'Cardamom',
    'Carrots',
    'Cashew Butter',
    'Cashews',
    'Cassava Flour',
    'Catfish',
    'Cauliflower',
    'Cayenne Pepper',
    'Celery',
    'Cheddar Cheese',
    'Cherries',
    'Cherry Tomatoes',
    'Chicken Broth',
    'Chicken Stock',
    'Chicken',
    'Chickpeas',
    'Chili Flakes',
    'Chili Powder',
    'Chives',
    'Cilantro',
    'Cinnamon',
    'Coconut Flour',
    'Coconut Oil',
    'Coconut',
    'Cod',
    'Colby Jack Cheese',
    'Collard Greens',
    'Confectioner Sugar',
    'Coriander',
    'Corn Tortilla Chips',
    'Corn',
    'Cottage Cheese',
    'Crab',
    'Cranberries',
    'Crawfish',
    'Cremini Mushrooms',
    'Cucumbers',
    'Cumin',
    'Dates',
    'Deli Meat',
    'Dill',
    'Egg Beaters',
    'Egg Noodles',
    'Egg Whites',
    'Egg Yolks',
    'Eggplant',
    'Eggs',
    'Evaporated Milk',
    'Farro',
    'Fennel',
    'Fennel',
    'Feta Cheese',
    'Figs',
    'Fish Broth',
    'Fish Sauce',
    'Fish',
    'Flaxseed',
    'Garbanzo Beans',
    'Garlic',
    'Ginger',
    'Gojuchang',
    'Gouda Cheese',
    'Grapefruits',
    'Grapes',
    'Grapeseed Oil',
    'Green Beans',
    'Green Chiles',
    'Green Olives',
    'Green Onions',
    'Grits',
    'Guacamole',
    'Half & Half',
    'Hash Browns',
    'Heavy Cream',
    'Heirloom Tomatoes',
    'Hoison Sauce',
    'Honey',
    'Honeydew',
    'Hot Peppers',
    'Hot Sauce',
    'Hot Sauce',
    'Hummus',
    'Iceberg Lettuce',
    'Jalapenos',
    'Kalamata Olives',
    'Kale',
    'Ketchup',
    'Key Limes',
    'Kidney Beans',
    'Kimchi',
    'Kiwis',
    'Kumquats',
    'Lavender',
    'Leeks',
    'Lemongrass',
    'Lemons',
    'Lentils',
    'Lima Beans',
    'Limes',
    'Liquid Eggs',
    'Lobster',
    'Lychee',
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
    'Oranges',
    'Oregano',
    'Oyster Sauce',
    'Paprika',
    'Parmesan Cheese',
    'Parsley',
    'Passion Fruit',
    'Pasta Shells',
    'Pasta',
    'Peaches',
    'Peanut Butter',
    'Peanuts',
    'Pears',
    'Peas',
    'Pecans',
    'Pepperjack Cheese',
    'Pesto',
    'Pickles',
    'Pine Nuts',
    'Pineapple',
    'Pinto Beans',
    'Pistachios',
    'Plantains',
    'Plums',
    'Pomegranates',
    'Porcini Mushrooms',
    'Pork',
    'Portabello Mushrooms',
    'Potato Chips',
    'Powdered Sugar',
    'Prawns',
    'Provolone Cheese',
    'Prunes',
    'Pumpkin',
    'Quinoa',
    'Radishes',
    'Raisins',
    'Raspberries',
    'Raspberry Jam',
    'Ravioli Pasta',
    'Red Cabbage',
    'Red Kidney Beans',
    'Red Onions',
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
    'Sage',
    'Salmon',
    'Salsa',
    'Salt',
    'Sauerkraut',
    'Sausage',
    'Scallions',
    'Scallops',
    'Sesame Oil',
    'Sesame Seeds',
    'Shallots',
    'Sherry Wine',
    'Shiitake Mushrooms',
    'Shrimp',
    'Snow Peas',
    'Sour Cream',
    'Soy Milk',
    'Soy Sauce',
    'Spinach',
    'Spring Mix',
    'Sriracha',
    'Strawberries',
    'Strawberry Jam',
    'Sugar',
    'Sunflower Seeds',
    'Sweet Potatoes',
    'Swiss Cheese',
    'Swordfish',
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
    'Tomatoes',
    'Tortillas',
    'Trout',
    'Turmeric',
    'Tuna',
    'Turnips',
    'Vegetable Oil',
    'Velveeta Cheese',
    'Venison',
    'Walnuts',
    'Watercress',
    'Watermelon',
    'Wheat Flour',
    'Wheat Tortilla Chips',
    'White Onions',
    'White Pepper',
    'White Potatoes',
    'White Rice',
    'White Sugar',
    'White Wine Vinegar',
    'White Wine',
    'Whole Star Anise',
    'Worcestershire Sauce',
    'Yams',
    'Yellow Onions',
    'Yellow Squash',
    'Zucchini',
    'Cantaloupe',
  ];
}
