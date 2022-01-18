// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      id: json['id'] as int,
      owner: json['owner'] as String,
      name: json['name'] as String,
      servings: json['servings'] as int,
      duration: json['duration'] as int,
      imageURL: json['image_url'] as String,
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => $enumDecode(_$TagEnumMap, e))
          .toList(),
      allergies: (json['allergies'] as List<dynamic>)
          .map((e) => $enumDecode(_$AllergyEnumMap, e))
          .toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'name': instance.name,
      'servings': instance.servings,
      'duration': instance.duration,
      'image_url': instance.imageURL,
      'steps': instance.steps,
      'ingredients': instance.ingredients,
      'tags': instance.tags.map((e) => _$TagEnumMap[e]).toList(),
      'allergies': instance.allergies.map((e) => _$AllergyEnumMap[e]).toList(),
      'comments': instance.comments,
    };

const _$TagEnumMap = {
  Tag.usa: 'usa',
  Tag.vietnam: 'vietnam',
  Tag.italy: 'italy',
  Tag.japan: 'japan',
  Tag.china: 'china',
  Tag.israel: 'israel',
  Tag.mexico: 'mexico',
  Tag.thailand: 'thailand',
  Tag.france: 'france',
  Tag.greece: 'greece',
  Tag.spain: 'spain',
  Tag.india: 'india',
  Tag.soup: 'soup',
  Tag.salad: 'salad',
  Tag.sandwich: 'sandwich',
  Tag.pasta: 'pasta',
  Tag.mainDish: 'mainDish',
  Tag.breakfast: 'breakfast',
  Tag.smallBite: 'smallBite',
  Tag.drink: 'drink',
  Tag.dessert: 'dessert',
  Tag.sour: 'sour',
  Tag.bitter: 'bitter',
  Tag.tangy: 'tangy',
  Tag.sweet: 'sweet',
  Tag.fruity: 'fruity',
  Tag.flaky: 'flaky',
  Tag.citrus: 'citrus',
  Tag.green: 'green',
  Tag.earthy: 'earthy',
  Tag.pungent: 'pungent',
  Tag.woody: 'woody',
  Tag.nutty: 'nutty',
  Tag.herby: 'herby',
  Tag.smoky: 'smoky',
  Tag.sulfur: 'sulfur',
  Tag.salty: 'salty',
  Tag.light: 'light',
  Tag.rich: 'rich',
  Tag.dry: 'dry',
  Tag.saucy: 'saucy',
  Tag.spicy: 'spicy',
  Tag.hot: 'hot',
  Tag.cold: 'cold',
  Tag.bready: 'bready',
  Tag.crunchy: 'crunchy',
  Tag.protein: 'protein',
  Tag.starchy: 'starchy',
  Tag.carby: 'carby',
  Tag.fatty: 'fatty',
  Tag.simple: 'simple',
  Tag.panFried: 'panFried',
  Tag.deepFried: 'deepFried',
  Tag.seared: 'seared',
  Tag.roasted: 'roasted',
  Tag.charred: 'charred',
  Tag.smoked: 'smoked',
  Tag.grilled: 'grilled',
  Tag.braised: 'braised',
  Tag.baked: 'baked',
};

const _$AllergyEnumMap = {
  Allergy.soy: 'soy',
  Allergy.gluten: 'gluten',
  Allergy.dairy: 'dairy',
  Allergy.egg: 'egg',
  Allergy.shellfish: 'shellfish',
  Allergy.sesame: 'sesame',
  Allergy.treeNuts: 'treeNuts',
  Allergy.peanuts: 'peanuts',
  Allergy.meat: 'meat',
  Allergy.seafood: 'seafood',
};
