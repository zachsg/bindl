// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Recipe _$$_RecipeFromJson(Map<String, dynamic> json) => _$_Recipe(
      id: json['id'] as int?,
      updatedAt: json['updated_at'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AllergyEnumMap, e))
              .toList() ??
          const [],
      appliances: (json['appliances'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ApplianceEnumMap, e))
              .toList() ??
          const [],
      cuisine: $enumDecode(_$CuisineEnumMap, json['cuisine']),
      diets: (json['diets'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DietEnumMap, e))
              .toList() ??
          const [],
      recipeType: $enumDecode(_$RecipeTypeEnumMap, json['recipe_type']),
      recipeTags: (json['recipe_tags'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$RecipeTagEnumMap, e))
              .toList() ??
          const [],
      servings: json['servings'] as int? ?? 2,
      cookTime: json['cook_time'] as int? ?? 20,
      prepTime: json['prep_time'] as int? ?? 10,
    );

Map<String, dynamic> _$$_RecipeToJson(_$_Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'updated_at': instance.updatedAt,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'video_url': instance.videoUrl,
      'steps': instance.steps,
      'ingredients': instance.ingredients,
      'allergies': instance.allergies.map((e) => _$AllergyEnumMap[e]).toList(),
      'appliances':
          instance.appliances.map((e) => _$ApplianceEnumMap[e]).toList(),
      'cuisine': _$CuisineEnumMap[instance.cuisine],
      'diets': instance.diets.map((e) => _$DietEnumMap[e]).toList(),
      'recipe_type': _$RecipeTypeEnumMap[instance.recipeType],
      'recipe_tags':
          instance.recipeTags.map((e) => _$RecipeTagEnumMap[e]).toList(),
      'servings': instance.servings,
      'cook_time': instance.cookTime,
      'prep_time': instance.prepTime,
    };

const _$AllergyEnumMap = {
  Allergy.wheat: 'wheat',
  Allergy.soy: 'soy',
  Allergy.dairy: 'dairy',
  Allergy.eggs: 'eggs',
  Allergy.shellfish: 'shellfish',
  Allergy.peanuts: 'peanuts',
  Allergy.treeNuts: 'treeNuts',
  Allergy.sesame: 'sesame',
};

const _$ApplianceEnumMap = {
  Appliance.oven: 'oven',
  Appliance.stovetop: 'stovetop',
  Appliance.airFryer: 'airFryer',
  Appliance.instantPot: 'instantPot',
  Appliance.blender: 'blender',
};

const _$CuisineEnumMap = {
  Cuisine.american: 'american',
  Cuisine.mexican: 'mexican',
  Cuisine.spanish: 'spanish',
  Cuisine.japanese: 'japanese',
  Cuisine.thai: 'thai',
  Cuisine.chinese: 'chinese',
  Cuisine.korean: 'korean',
  Cuisine.german: 'german',
  Cuisine.italian: 'italian',
  Cuisine.french: 'french',
  Cuisine.indian: 'indian',
  Cuisine.caribbean: 'caribbean',
};

const _$DietEnumMap = {
  Diet.paleo: 'paleo',
  Diet.keto: 'keto',
  Diet.vegetarian: 'vegetarian',
  Diet.vegan: 'vegan',
  Diet.omnivore: 'omnivore',
};

const _$RecipeTypeEnumMap = {
  RecipeType.breakfast: 'breakfast',
  RecipeType.lunch: 'lunch',
  RecipeType.dinner: 'dinner',
  RecipeType.appetizer: 'appetizer',
  RecipeType.drink: 'drink',
  RecipeType.soup: 'soup',
  RecipeType.sandwich: 'sandwich',
};

const _$RecipeTagEnumMap = {
  RecipeTag.sour: 'sour',
  RecipeTag.bitter: 'bitter',
  RecipeTag.tangy: 'tangy',
  RecipeTag.sweet: 'sweet',
  RecipeTag.fruity: 'fruity',
  RecipeTag.flaky: 'flaky',
  RecipeTag.citrus: 'citrus',
  RecipeTag.green: 'green',
  RecipeTag.earthy: 'earthy',
  RecipeTag.pungent: 'pungent',
  RecipeTag.woody: 'woody',
  RecipeTag.nutty: 'nutty',
  RecipeTag.herby: 'herby',
  RecipeTag.smoky: 'smoky',
  RecipeTag.sulfur: 'sulfur',
  RecipeTag.salty: 'salty',
  RecipeTag.light: 'light',
  RecipeTag.rich: 'rich',
  RecipeTag.dry: 'dry',
  RecipeTag.saucy: 'saucy',
  RecipeTag.spicy: 'spicy',
  RecipeTag.hot: 'hot',
  RecipeTag.cold: 'cold',
  RecipeTag.bready: 'bready',
  RecipeTag.crunchy: 'crunchy',
  RecipeTag.protein: 'protein',
  RecipeTag.starchy: 'starchy',
  RecipeTag.carby: 'carby',
  RecipeTag.fatty: 'fatty',
  RecipeTag.simple: 'simple',
  RecipeTag.panFried: 'panFried',
  RecipeTag.deepFried: 'deepFried',
  RecipeTag.seared: 'seared',
  RecipeTag.roasted: 'roasted',
  RecipeTag.charred: 'charred',
  RecipeTag.smoked: 'smoked',
  RecipeTag.grilled: 'grilled',
  RecipeTag.braised: 'braised',
  RecipeTag.baked: 'baked',
};
