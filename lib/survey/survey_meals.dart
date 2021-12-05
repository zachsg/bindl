import 'package:bindl/shared/tag.dart';
import 'package:bindl/survey/survey_meal.dart';

class SurveyMeals {
  static get all =>
      chinese +
      thai +
      vietnamese +
      japanese +
      indian +
      greek +
      italian +
      french +
      american +
      latin +
      breakfast;

  static const String _assetURL = 'assets/images/';

  static const chinese = [
    SurveyMeal(
      name: "Sweet & Sour Chicken",
      image: '$_assetURL/sweet_and_sour_chicken.jpeg',
      tags: [
        Tag.asian,
        Tag.chinese,
        Tag.balancedCarb,
        Tag.meat,
        Tag.chicken,
        Tag.sweet,
      ],
    ),
    SurveyMeal(
      name: "Spicy Mongolian Beef",
      image: '$_assetURL/mongolian_beef.jpeg',
      tags: [
        Tag.asian,
        Tag.chinese,
        Tag.lowCarb,
        Tag.meat,
        Tag.savory,
        Tag.spicy,
      ],
    ),
    SurveyMeal(
      name: "Egg Rolls",
      image: '$_assetURL/egg_rolls.jpeg',
      tags: [
        Tag.asian,
        Tag.chinese,
        Tag.balancedCarb,
        Tag.vegetarian,
        Tag.sandwich,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Stir Fry",
      image: '$_assetURL/stir_fry.jpeg',
      tags: [
        Tag.asian,
        Tag.chinese,
        Tag.lowCarb,
        Tag.vegetarian,
        Tag.salty,
      ],
    ),
  ];

  static const thai = [
    SurveyMeal(
      name: "Pad Thai",
      image: '$_assetURL/pad_thai.jpeg',
      tags: [
        Tag.asian,
        Tag.thai,
        Tag.highCarb,
        Tag.pasta,
        Tag.sweet,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Spicy Thai Curry",
      image: '$_assetURL/thai_curry.jpeg',
      tags: [
        Tag.asian,
        Tag.thai,
        Tag.lowCarb,
        Tag.spicy,
        Tag.savory,
      ],
    )
  ];

  static const vietnamese = [
    SurveyMeal(
      name: "Pho",
      image: '$_assetURL/pho.jpeg',
      tags: [
        Tag.asian,
        Tag.balancedCarb,
        Tag.pasta,
        Tag.soup,
        Tag.salty,
      ],
    ),
    SurveyMeal(
      name: "Banh Mi",
      image: '$_assetURL/banh_mi.jpeg',
      tags: [
        Tag.asian,
        Tag.highCarb,
        Tag.meat,
        Tag.sandwich,
        Tag.savory,
      ],
    ),
  ];

  static const japanese = [
    SurveyMeal(
      name: "Sushi",
      image: '$_assetURL/sushi.jpeg',
      tags: [
        Tag.asian,
        Tag.japanese,
        Tag.balancedCarb,
        Tag.seafood,
        Tag.salty,
      ],
    ),
    SurveyMeal(
      name: "Salmon Teriyaki",
      image: '$_assetURL/salmon_teriyaki.jpeg',
      tags: [
        Tag.asian,
        Tag.japanese,
        Tag.lowCarb,
        Tag.seafood,
        Tag.sweet,
      ],
    ),
    SurveyMeal(
      name: "Ramen",
      image: '$_assetURL/ramen.jpeg',
      tags: [
        Tag.asian,
        Tag.japanese,
        Tag.highCarb,
        Tag.pasta,
        Tag.soup,
        Tag.salty,
      ],
    ),
  ];

  static const indian = [
    SurveyMeal(
      name: "Chicken Tikka Masala",
      image: '$_assetURL/chicken_tikka_masala.jpeg',
      tags: [
        Tag.indian,
        Tag.lowCarb,
        Tag.meat,
        Tag.chicken,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Veggie Curry",
      image: '$_assetURL/veggie_curry.jpeg',
      tags: [
        Tag.indian,
        Tag.lowCarb,
        Tag.vegetarian,
        Tag.savory,
      ],
    ),
  ];

  static const greek = [
    SurveyMeal(
      name: "Lamb Gyro",
      image: '$_assetURL/lamb_gyro.jpeg',
      tags: [
        Tag.greek,
        Tag.balancedCarb,
        Tag.meat,
        Tag.sandwich,
        Tag.salty,
      ],
    ),
    SurveyMeal(
      name: "Hummus",
      image: '$_assetURL/hummus.jpeg',
      tags: [
        Tag.greek,
        Tag.lowCarb,
        Tag.vegetarian,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Greek Salad",
      image: '$_assetURL/greek_salad.jpeg',
      tags: [
        Tag.greek,
        Tag.lowCarb,
        Tag.vegetarian,
        Tag.salad,
        Tag.salty,
      ],
    ),
  ];

  static const italian = [
    SurveyMeal(
      name: "Veggie Lasagna",
      image: '$_assetURL/veggie_lasagna.jpeg',
      tags: [
        Tag.italian,
        Tag.highCarb,
        Tag.vegetarian,
        Tag.pasta,
        Tag.savory,
        Tag.sweet,
      ],
    ),
    SurveyMeal(
      name: "Spaghetti and Meatballs",
      image: '$_assetURL/spaghetti_and_meatballs.jpeg',
      tags: [
        Tag.italian,
        Tag.highCarb,
        Tag.meat,
        Tag.pasta,
        Tag.savory,
        Tag.salty,
      ],
    ),
    SurveyMeal(
      name: "Pizza",
      image: '$_assetURL/pizza.jpeg',
      tags: [
        Tag.italian,
        Tag.highCarb,
        Tag.sandwich,
        Tag.savory,
      ],
    ),
  ];

  static const french = [
    SurveyMeal(
      name: "French Onion Soup",
      image: '$_assetURL/french_onion_soup.jpeg',
      tags: [
        Tag.french,
        Tag.lowCarb,
        Tag.soup,
        Tag.salty,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Steak Frites",
      image: '$_assetURL/steak_frites.jpeg',
      tags: [
        Tag.french,
        Tag.balancedCarb,
        Tag.meat,
        Tag.savory,
      ],
    ),
  ];

  static const american = [
    SurveyMeal(
      name: "Hamburger",
      image: '$_assetURL/hamburger.jpeg',
      tags: [
        Tag.american,
        Tag.balancedCarb,
        Tag.meat,
        Tag.sandwich,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Baked Potato",
      image: '$_assetURL/baked_potato.jpeg',
      tags: [
        Tag.american,
        Tag.highCarb,
        Tag.vegetarian,
        Tag.salty,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Caesar Salad",
      image: '$_assetURL/caesar_salad.jpeg',
      tags: [
        Tag.american,
        Tag.lowCarb,
        Tag.seafood,
        Tag.salad,
        Tag.salty,
      ],
    ),
    SurveyMeal(
      name: "Fruit Bowl",
      image: '$_assetURL/fruit_bowl.jpeg',
      tags: [
        Tag.american,
        Tag.highCarb,
        Tag.vegetarian,
        Tag.fruit,
        Tag.salad,
        Tag.sweet,
      ],
    ),
    SurveyMeal(
      name: "Scallops",
      image: '$_assetURL/scallops.jpeg',
      tags: [
        Tag.american,
        Tag.lowCarb,
        Tag.seafood,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Blackened Cod",
      image: '$_assetURL/blackened_cod.jpeg',
      tags: [
        Tag.american,
        Tag.lowCarb,
        Tag.seafood,
        Tag.savory,
      ],
    ),
  ];

  static const latin = [
    SurveyMeal(
      name: "Bean Burrito",
      image: '$_assetURL/bean_burrito.jpeg',
      tags: [
        Tag.latin,
        Tag.highCarb,
        Tag.vegetarian,
        Tag.sandwich,
        Tag.salty,
      ],
    ),
    SurveyMeal(
      name: "Fish Tacos",
      image: '$_assetURL/fish_tacos.jpeg',
      tags: [
        Tag.latin,
        Tag.balancedCarb,
        Tag.seafood,
        Tag.sandwich,
        Tag.salty,
      ],
    ),
    SurveyMeal(
      name: "Fajitas",
      image: '$_assetURL/fajitas.jpeg',
      tags: [
        Tag.latin,
        Tag.lowCarb,
        Tag.meat,
        Tag.savory,
      ],
    ),
  ];

  static const breakfast = [
    SurveyMeal(
      name: "Veggie Omelette",
      image: '$_assetURL/veggie_omelette.jpeg',
      tags: [
        Tag.lowCarb,
        Tag.vegetarian,
        Tag.breakfast,
        Tag.savory,
      ],
    ),
    SurveyMeal(
      name: "Breakfast Burrito",
      image: '$_assetURL/breakfast_burrito.jpeg',
      tags: [
        Tag.balancedCarb,
        Tag.vegetarian,
        Tag.meat,
        Tag.breakfast,
        Tag.savory,
        Tag.salty,
      ],
    ),
    SurveyMeal(
      name: "Pancakes",
      image: '$_assetURL/pancakes.jpeg',
      tags: [
        Tag.highCarb,
        Tag.vegetarian,
        Tag.breakfast,
        Tag.sweet,
      ],
    ),
    SurveyMeal(
      name: "Fruit Parfait",
      image: '$_assetURL/fruit_parfait.jpeg',
      tags: [
        Tag.balancedCarb,
        Tag.vegetarian,
        Tag.fruit,
        Tag.breakfast,
        Tag.sweet,
      ],
    ),
    SurveyMeal(
      name: "Fruit Smoothie",
      image: '$_assetURL/fruit_smoothie.jpeg',
      tags: [
        Tag.highCarb,
        Tag.vegetarian,
        Tag.fruit,
        Tag.breakfast,
        Tag.sweet,
      ],
    ),
  ];
}
