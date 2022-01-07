// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      updatedAt: json['updated_at'] as String,
      name: json['username'] as String,
      tags: (json['tags'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$TagEnumMap, k), e as int),
      ),
      allergies: (json['allergies'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$AllergyEnumMap, k), e as bool),
      ),
      adoreIngredients: (json['adore_ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      abhorIngredients: (json['abhor_ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recipes: (json['recipes'] as List<dynamic>).map((e) => e as int).toList(),
      recipesLiked: (json['recipes_old_liked'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      recipesDisliked: (json['recipes_old_disliked'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      servings: json['servings'] as int,
      numMeals: json['num_meals'] as int,
      pantry: (json['pantry'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasAccount: json['hasAccount'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'updated_at': instance.updatedAt,
      'username': instance.name,
      'tags': instance.tags.map((k, e) => MapEntry(_$TagEnumMap[k], e)),
      'allergies':
          instance.allergies.map((k, e) => MapEntry(_$AllergyEnumMap[k], e)),
      'adore_ingredients': instance.adoreIngredients,
      'abhor_ingredients': instance.abhorIngredients,
      'recipes': instance.recipes,
      'recipes_old_liked': instance.recipesLiked,
      'recipes_old_disliked': instance.recipesDisliked,
      'servings': instance.servings,
      'num_meals': instance.numMeals,
      'pantry': instance.pantry,
      'hasAccount': instance.hasAccount,
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
