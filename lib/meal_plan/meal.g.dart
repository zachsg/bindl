// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      json['id'] as int,
      json['name'] as String,
      json['servings'] as int,
      json['duration'] as int,
      json['image_url'] as String,
      (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['tags'] as List<dynamic>)
          .map((e) => $enumDecode(_$TagEnumMap, e))
          .toList(),
      (json['allergies'] as List<dynamic>)
          .map((e) => $enumDecode(_$AllergyEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'servings': instance.servings,
      'duration': instance.duration,
      'image_url': instance.imageURL,
      'steps': instance.steps,
      'ingredients': instance.ingredients,
      'tags': instance.tags.map((e) => _$TagEnumMap[e]).toList(),
      'allergies': instance.allergies.map((e) => _$AllergyEnumMap[e]).toList(),
    };

const _$TagEnumMap = {
  Tag.asian: 'asian',
  Tag.japanese: 'japanese',
  Tag.thai: 'thai',
  Tag.chinese: 'chinese',
  Tag.indian: 'indian',
  Tag.greek: 'greek',
  Tag.italian: 'italian',
  Tag.french: 'french',
  Tag.american: 'american',
  Tag.latin: 'latin',
  Tag.lowCarb: 'lowCarb',
  Tag.highCarb: 'highCarb',
  Tag.balancedCarb: 'balancedCarb',
  Tag.vegetarian: 'vegetarian',
  Tag.meat: 'meat',
  Tag.seafood: 'seafood',
  Tag.chicken: 'chicken',
  Tag.fruit: 'fruit',
  Tag.breakfast: 'breakfast',
  Tag.soup: 'soup',
  Tag.salad: 'salad',
  Tag.sandwich: 'sandwich',
  Tag.pasta: 'pasta',
  Tag.sweet: 'sweet',
  Tag.salty: 'salty',
  Tag.savory: 'savory',
  Tag.spicy: 'spicy',
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
};
