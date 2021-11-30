// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      json['id'] as int,
      json['name'] as String,
      json['image_url'] as String,
      (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['tags'] as List<dynamic>)
          .map((e) => $enumDecode(_$TagEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageURL,
      'steps': instance.steps,
      'ingredients': instance.ingredients,
      'tags': instance.tags.map((e) => _$TagEnumMap[e]).toList(),
    };

const _$TagEnumMap = {
  Tag.asian: 'asian',
  Tag.japanese: 'japanese',
  Tag.thai: 'thai',
  Tag.vietnamese: 'vietnamese',
  Tag.chinese: 'chinese',
  Tag.indian: 'indian',
  Tag.mediterranean: 'mediterranean',
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
  Tag.beef: 'beef',
  Tag.lamb: 'lamb',
  Tag.fruit: 'fruit',
  Tag.vegetable: 'vegetable',
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
