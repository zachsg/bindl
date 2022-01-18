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
      hasAccount: json['has_account'] as bool? ?? false,
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
      'has_account': instance.hasAccount,
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
