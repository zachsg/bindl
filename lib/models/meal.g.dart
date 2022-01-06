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
  Tag.tangy: 'tangy',
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
