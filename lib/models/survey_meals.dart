import 'package:bodai/models/xmodels.dart';

class SurveyMeals {
  static get all =>
      asian + indian + westernEuropean + northAmerican + southAmerican;

  static const String _assetURL = 'assets/images';

  static const asian = [
    SurveyMeal(
      name: "Sweet & Sour Chicken",
      image: '$_assetURL/sweet_and_sour_chicken.jpeg',
      tags: [
        Tag.china,
        Tag.mainDish,
        Tag.sour,
        Tag.sweet,
        Tag.rich,
        Tag.hot,
        Tag.bready,
        Tag.saucy,
        Tag.protein,
        Tag.carby,
        Tag.deepFried,
      ],
    ),
    SurveyMeal(
      name: "Spicy Mongolian Beef",
      image: '$_assetURL/mongolian_beef.jpeg',
      tags: [
        Tag.china,
        Tag.mainDish,
        Tag.salty,
        Tag.rich,
        Tag.spicy,
        Tag.hot,
        Tag.protein,
        Tag.panFried,
      ],
    ),
    SurveyMeal(
      name: "Egg Rolls",
      image: '$_assetURL/egg_rolls.jpeg',
      tags: [
        Tag.china,
        Tag.sandwich,
        Tag.smallBite,
        Tag.sweet,
        Tag.light,
        Tag.hot,
        Tag.crunchy,
        Tag.deepFried,
      ],
    ),
    SurveyMeal(
      name: "Stir Fry",
      image: '$_assetURL/stir_fry.jpeg',
      tags: [
        Tag.thailand,
        Tag.mainDish,
        Tag.green,
        Tag.sulfur,
        Tag.earthy,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.panFried,
      ],
    ),
    SurveyMeal(
      name: "Pad Thai",
      image: '$_assetURL/pad_thai.jpeg',
      tags: [
        Tag.thailand,
        Tag.mainDish,
        Tag.pasta,
        Tag.sweet,
        Tag.tangy,
        Tag.citrus,
        Tag.rich,
        Tag.spicy,
        Tag.hot,
        Tag.carby,
        Tag.panFried,
      ],
    ),
    SurveyMeal(
      name: "Spicy Thai Curry",
      image: '$_assetURL/thai_curry.jpeg',
      tags: [
        Tag.thailand,
        Tag.mainDish,
        Tag.green,
        Tag.earthy,
        Tag.spicy,
        Tag.light,
        Tag.hot,
        Tag.fatty,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Pho",
      image: '$_assetURL/pho.jpeg',
      tags: [
        Tag.vietnam,
        Tag.soup,
        Tag.mainDish,
        Tag.green,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.protein,
      ],
    ),
    SurveyMeal(
      name: "Banh Mi",
      image: '$_assetURL/banh_mi.jpeg',
      tags: [
        Tag.vietnam,
        Tag.sandwich,
        Tag.light,
        Tag.cold,
        Tag.bready,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Sushi",
      image: '$_assetURL/sushi.jpeg',
      tags: [
        Tag.japan,
        Tag.mainDish,
        Tag.sweet,
        Tag.salty,
        Tag.carby,
        Tag.hot,
        Tag.cold,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Salmon Teriyaki",
      image: '$_assetURL/salmon_teriyaki.jpeg',
      tags: [
        Tag.japan,
        Tag.mainDish,
        Tag.sweet,
        Tag.salty,
        Tag.saucy,
        Tag.hot,
        Tag.protein,
        Tag.panFried,
      ],
    ),
    SurveyMeal(
      name: "Ramen",
      image: '$_assetURL/ramen.jpeg',
      tags: [
        Tag.japan,
        Tag.soup,
        Tag.mainDish,
        Tag.green,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.protein,
      ],
    ),
  ];

  static const indian = [
    SurveyMeal(
      name: "Chicken Tikka Masala",
      image: '$_assetURL/chicken_tikka_masala.jpeg',
      tags: [
        Tag.india,
        Tag.mainDish,
        Tag.earthy,
        Tag.rich,
        Tag.saucy,
        Tag.hot,
        Tag.protein,
        Tag.carby,
        Tag.spicy,
        Tag.sweet,
      ],
    ),
    SurveyMeal(
      name: "Veggie Curry",
      image: '$_assetURL/veggie_curry.jpeg',
      tags: [
        Tag.india,
        Tag.mainDish,
        Tag.sweet,
        Tag.earthy,
        Tag.rich,
        Tag.saucy,
        Tag.spicy,
        Tag.hot,
        Tag.fatty,
      ],
    ),
  ];

  static const westernEuropean = [
    SurveyMeal(
      name: "Lamb Gyro",
      image: '$_assetURL/lamb_gyro.jpeg',
      tags: [
        Tag.greece,
        Tag.sandwich,
        Tag.mainDish,
        Tag.tangy,
        Tag.pungent,
        Tag.green,
        Tag.salty,
        Tag.hot,
        Tag.simple,
        Tag.bready,
        Tag.carby,
        Tag.braised,
      ],
    ),
    SurveyMeal(
      name: "Hummus",
      image: '$_assetURL/hummus.jpeg',
      tags: [
        Tag.israel,
        Tag.smallBite,
        Tag.starchy,
        Tag.earthy,
        Tag.salty,
        Tag.light,
        Tag.cold,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Greek Salad",
      image: '$_assetURL/greek_salad.jpeg',
      tags: [
        Tag.greece,
        Tag.salad,
        Tag.smallBite,
        Tag.salty,
        Tag.tangy,
        Tag.green,
        Tag.light,
        Tag.saucy,
        Tag.cold,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Veggie Lasagna",
      image: '$_assetURL/veggie_lasagna.jpeg',
      tags: [
        Tag.italy,
        Tag.pasta,
        Tag.mainDish,
        Tag.sweet,
        Tag.tangy,
        Tag.salty,
        Tag.rich,
        Tag.saucy,
        Tag.hot,
        Tag.starchy,
        Tag.carby,
        Tag.fatty,
        Tag.baked,
      ],
    ),
    SurveyMeal(
      name: "Spaghetti and Meatballs",
      image: '$_assetURL/spaghetti_and_meatballs.jpeg',
      tags: [
        Tag.italy,
        Tag.pasta,
        Tag.mainDish,
        Tag.sweet,
        Tag.tangy,
        Tag.salty,
        Tag.rich,
        Tag.saucy,
        Tag.hot,
        Tag.starchy,
        Tag.carby,
        Tag.fatty,
      ],
    ),
    SurveyMeal(
      name: "Pizza",
      image: '$_assetURL/pizza.jpeg',
      tags: [
        Tag.italy,
        Tag.mainDish,
        Tag.sweet,
        Tag.tangy,
        Tag.hot,
        Tag.saucy,
        Tag.bready,
        Tag.carby,
        Tag.fatty,
        Tag.baked,
      ],
    ),
    SurveyMeal(
      name: "French Onion Soup",
      image: '$_assetURL/french_onion_soup.jpeg',
      tags: [
        Tag.france,
        Tag.soup,
        Tag.smallBite,
        Tag.sweet,
        Tag.salty,
        Tag.light,
        Tag.bready,
        Tag.sulfur,
        Tag.simple,
        Tag.hot,
      ],
    ),
    SurveyMeal(
      name: "Steak Frites",
      image: '$_assetURL/steak_frites.jpeg',
      tags: [
        Tag.france,
        Tag.mainDish,
        Tag.smallBite,
        Tag.tangy,
        Tag.salty,
        Tag.rich,
        Tag.hot,
        Tag.protein,
        Tag.starchy,
        Tag.panFried,
      ],
    ),
    SurveyMeal(
      name: "Veggie Omelette",
      image: '$_assetURL/veggie_omelette.jpeg',
      tags: [
        Tag.france,
        Tag.breakfast,
        Tag.green,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.protein,
        Tag.panFried,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Fruit Parfait",
      image: '$_assetURL/fruit_parfait.jpeg',
      tags: [
        Tag.france,
        Tag.breakfast,
        Tag.dessert,
        Tag.sweet,
        Tag.tangy,
        Tag.fruity,
        Tag.light,
        Tag.cold,
        Tag.fatty,
        Tag.carby,
        Tag.simple,
      ],
    ),
  ];

  static const northAmerican = [
    SurveyMeal(
      name: "Hamburger",
      image: '$_assetURL/hamburger.jpeg',
      tags: [
        Tag.usa,
        Tag.sandwich,
        Tag.mainDish,
        Tag.salty,
        Tag.rich,
        Tag.dry,
        Tag.hot,
        Tag.bready,
        Tag.protein,
        Tag.carby,
        Tag.grilled,
      ],
    ),
    SurveyMeal(
      name: "Baked Potato",
      image: '$_assetURL/baked_potato.jpeg',
      tags: [
        Tag.usa,
        Tag.smallBite,
        Tag.earthy,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.starchy,
        Tag.baked,
      ],
    ),
    SurveyMeal(
      name: "Caesar Salad",
      image: '$_assetURL/caesar_salad.jpeg',
      tags: [
        Tag.usa,
        Tag.salad,
        Tag.smallBite,
        Tag.salty,
        Tag.tangy,
        Tag.light,
        Tag.cold,
        Tag.saucy,
        Tag.green,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Fruit Bowl",
      image: '$_assetURL/fruit_bowl.jpeg',
      tags: [
        Tag.usa,
        Tag.breakfast,
        Tag.smallBite,
        Tag.sweet,
        Tag.tangy,
        Tag.fruity,
        Tag.light,
        Tag.cold,
        Tag.carby,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Scallops",
      image: '$_assetURL/scallops.jpeg',
      tags: [
        Tag.usa,
        Tag.mainDish,
        Tag.sweet,
        Tag.pungent,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.protein,
        Tag.nutty,
        Tag.seared,
        Tag.panFried,
      ],
    ),
    SurveyMeal(
      name: "Blackened Cod",
      image: '$_assetURL/blackened_cod.jpeg',
      tags: [
        Tag.usa,
        Tag.mainDish,
        Tag.flaky,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.charred,
        Tag.protein,
      ],
    ),
    SurveyMeal(
      name: "Pancakes",
      image: '$_assetURL/pancakes.jpeg',
      tags: [
        Tag.usa,
        Tag.breakfast,
        Tag.sweet,
        Tag.rich,
        Tag.dry,
        Tag.hot,
        Tag.bready,
        Tag.carby,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Fruit Smoothie",
      image: '$_assetURL/fruit_smoothie.jpeg',
      tags: [
        Tag.usa,
        Tag.breakfast,
        Tag.saucy,
        Tag.sweet,
        Tag.tangy,
        Tag.fruity,
        Tag.light,
        Tag.cold,
        Tag.carby,
        Tag.simple,
      ],
    ),
  ];

  static const southAmerican = [
    SurveyMeal(
      name: "Bean Burrito",
      image: '$_assetURL/bean_burrito.jpeg',
      tags: [
        Tag.mexico,
        Tag.sandwich,
        Tag.mainDish,
        Tag.sweet,
        Tag.earthy,
        Tag.salty,
        Tag.rich,
        Tag.hot,
        Tag.bready,
        Tag.starchy,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Fish Tacos",
      image: '$_assetURL/fish_tacos.jpeg',
      tags: [
        Tag.mexico,
        Tag.sandwich,
        Tag.smallBite,
        Tag.tangy,
        Tag.citrus,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.starchy,
        Tag.protein,
        Tag.simple,
      ],
    ),
    SurveyMeal(
      name: "Fajitas",
      image: '$_assetURL/fajitas.jpeg',
      tags: [
        Tag.mexico,
        Tag.mainDish,
        Tag.sweet,
        Tag.green,
        Tag.sulfur,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.protein,
        Tag.panFried,
      ],
    ),
    SurveyMeal(
      name: "Breakfast Burrito",
      image: '$_assetURL/breakfast_burrito.jpeg',
      tags: [
        Tag.mexico,
        Tag.breakfast,
        Tag.sandwich,
        Tag.sweet,
        Tag.starchy,
        Tag.salty,
        Tag.light,
        Tag.hot,
        Tag.protein,
        Tag.carby,
        Tag.simple,
      ],
    ),
  ];
}
