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

  static const chinese = [
    SurveyMeal(name: "Sweet and Sour Chicken", image: '', tags: [
      Tag.asian,
      Tag.chinese,
      Tag.balancedCarb,
      Tag.meat,
      Tag.chicken,
      Tag.sweet,
    ]),
    SurveyMeal(name: "Spicy Mongolian Beef", image: '', tags: [
      Tag.asian,
      Tag.chinese,
      Tag.lowCarb,
      Tag.meat,
      Tag.savory,
      Tag.spicy,
    ]),
    SurveyMeal(name: "Egg Rolls", image: '', tags: [
      Tag.asian,
      Tag.chinese,
      Tag.balancedCarb,
      Tag.vegetarian,
      Tag.vegetable,
      Tag.sandwich,
      Tag.savory,
    ]),
    SurveyMeal(name: "Stir Fry", image: '', tags: [
      Tag.asian,
      Tag.chinese,
      Tag.lowCarb,
      Tag.vegetarian,
      Tag.vegetable,
      Tag.salty,
    ])
  ];

  static const thai = [
    SurveyMeal(name: "Pad Thai", image: '', tags: [
      Tag.asian,
      Tag.thai,
      Tag.highCarb,
      Tag.pasta,
      Tag.sweet,
      Tag.savory,
    ]),
    SurveyMeal(name: "Spicy Thai Curry", image: '', tags: [
      Tag.asian,
      Tag.thai,
      Tag.lowCarb,
      Tag.vegetable,
      Tag.spicy,
      Tag.savory,
    ])
  ];

  static const vietnamese = [
    SurveyMeal(name: "Pho", image: '', tags: [
      Tag.asian,
      Tag.vietnamese,
      Tag.balancedCarb,
      Tag.pasta,
      Tag.soup,
      Tag.vegetable,
      Tag.salty,
    ]),
    SurveyMeal(name: "Banh Mi", image: '', tags: [
      Tag.asian,
      Tag.vietnamese,
      Tag.highCarb,
      Tag.vegetarian,
      Tag.vegetable,
      Tag.sandwich,
      Tag.savory,
    ])
  ];

  static const japanese = [
    SurveyMeal(name: "Sushi", image: '', tags: [
      Tag.asian,
      Tag.japanese,
      Tag.balancedCarb,
      Tag.seafood,
      Tag.salty,
    ]),
    SurveyMeal(name: "Salmon Teriyaki", image: '', tags: [
      Tag.asian,
      Tag.japanese,
      Tag.lowCarb,
      Tag.seafood,
      Tag.sweet,
    ]),
    SurveyMeal(name: "Ramen", image: '', tags: [
      Tag.asian,
      Tag.japanese,
      Tag.highCarb,
      Tag.pasta,
      Tag.soup,
      Tag.vegetable,
      Tag.salty,
    ])
  ];

  static const indian = [
    SurveyMeal(name: "Chicken Tikka Masala", image: '', tags: [
      Tag.asian,
      Tag.indian,
      Tag.lowCarb,
      Tag.meat,
      Tag.chicken,
      Tag.savory,
    ]),
    SurveyMeal(name: "Veggie Curry", image: '', tags: [
      Tag.asian,
      Tag.indian,
      Tag.lowCarb,
      Tag.vegetarian,
      Tag.vegetable,
      Tag.savory,
    ])
  ];

  static const greek = [
    SurveyMeal(name: "Lamb Gyro", image: '', tags: [
      Tag.mediterranean,
      Tag.greek,
      Tag.balancedCarb,
      Tag.meat,
      Tag.sandwich,
      Tag.salty,
    ]),
    SurveyMeal(name: "Hummus", image: '', tags: [
      Tag.mediterranean,
      Tag.greek,
      Tag.lowCarb,
      Tag.vegetarian,
      Tag.savory,
    ]),
    SurveyMeal(name: "Greek Salad", image: '', tags: [
      Tag.mediterranean,
      Tag.greek,
      Tag.lowCarb,
      Tag.vegetarian,
      Tag.vegetable,
      Tag.salad,
      Tag.salty,
    ])
  ];

  static const italian = [
    SurveyMeal(name: "Veggie Lasagna", image: '', tags: [
      Tag.mediterranean,
      Tag.italian,
      Tag.highCarb,
      Tag.vegetarian,
      Tag.pasta,
      Tag.savory,
      Tag.sweet,
    ]),
    SurveyMeal(name: "Spaghetti and Meatballs", image: '', tags: [
      Tag.mediterranean,
      Tag.italian,
      Tag.highCarb,
      Tag.meat,
      Tag.pasta,
      Tag.savory,
      Tag.salty,
    ]),
    SurveyMeal(name: "Pizza", image: '', tags: [
      Tag.mediterranean,
      Tag.italian,
      Tag.highCarb,
      Tag.sandwich,
      Tag.savory,
    ]),
  ];

  static const french = [
    SurveyMeal(name: "French Onion Soup", image: '', tags: [
      Tag.mediterranean,
      Tag.french,
      Tag.lowCarb,
      Tag.soup,
      Tag.salty,
      Tag.savory,
    ]),
    SurveyMeal(name: "Steak Frites", image: '', tags: [
      Tag.mediterranean,
      Tag.french,
      Tag.balancedCarb,
      Tag.meat,
      Tag.savory,
    ])
  ];

  static const american = [
    SurveyMeal(name: "Hamburger", image: '', tags: [
      Tag.american,
      Tag.balancedCarb,
      Tag.meat,
      Tag.sandwich,
      Tag.savory,
    ]),
    SurveyMeal(name: "Baked Potato", image: '', tags: [
      Tag.american,
      Tag.highCarb,
      Tag.vegetarian,
      Tag.salty,
      Tag.savory,
    ]),
    SurveyMeal(name: "Caesar Salad", image: '', tags: [
      Tag.american,
      Tag.lowCarb,
      Tag.seafood,
      Tag.salad,
      Tag.vegetable,
      Tag.salty,
    ]),
    SurveyMeal(name: "Fruit Bowl", image: '', tags: [
      Tag.american,
      Tag.highCarb,
      Tag.vegetarian,
      Tag.fruit,
      Tag.salad,
      Tag.sweet,
    ]),
    SurveyMeal(name: "Scallops", image: '', tags: [
      Tag.american,
      Tag.lowCarb,
      Tag.seafood,
      Tag.savory,
    ]),
    SurveyMeal(name: "Blackened Cod", image: '', tags: [
      Tag.american,
      Tag.lowCarb,
      Tag.seafood,
      Tag.savory,
    ]),
  ];

  static const latin = [
    SurveyMeal(name: "Bean Burrito", image: '', tags: [
      Tag.latin,
      Tag.highCarb,
      Tag.vegetarian,
      Tag.sandwich,
      Tag.salty,
    ]),
    SurveyMeal(name: "Fish Tacos", image: '', tags: [
      Tag.latin,
      Tag.balancedCarb,
      Tag.seafood,
      Tag.sandwich,
      Tag.salty,
    ]),
    SurveyMeal(name: "Fajitas", image: '', tags: [
      Tag.latin,
      Tag.lowCarb,
      Tag.meat,
      Tag.vegetable,
      Tag.savory,
    ]),
  ];

  static const breakfast = [
    SurveyMeal(name: "Veggie Omelette", image: '', tags: [
      Tag.lowCarb,
      Tag.vegetarian,
      Tag.vegetable,
      Tag.breakfast,
      Tag.savory,
    ]),
    SurveyMeal(name: "Breakfast Burrito", image: '', tags: [
      Tag.balancedCarb,
      Tag.vegetarian,
      Tag.meat,
      Tag.breakfast,
      Tag.savory,
      Tag.salty,
    ]),
    SurveyMeal(name: "Pancakes", image: '', tags: [
      Tag.highCarb,
      Tag.vegetarian,
      Tag.breakfast,
      Tag.sweet,
    ]),
    SurveyMeal(name: "Fruit Parfait", image: '', tags: [
      Tag.balancedCarb,
      Tag.vegetarian,
      Tag.fruit,
      Tag.breakfast,
      Tag.sweet,
    ]),
    SurveyMeal(name: "Fruit Smoothie", image: '', tags: [
      Tag.highCarb,
      Tag.vegetarian,
      Tag.fruit,
      Tag.breakfast,
      Tag.sweet,
    ])
  ];
}
