// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Ingredient _$$_IngredientFromJson(Map<String, dynamic> json) =>
    _$_Ingredient(
      id: json['id'] as int,
      name: json['name'] as String,
      category: $enumDecode(_$IngredientCategoryEnumMap, json['category']),
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      measurement: $enumDecodeNullable(
              _$IngredientMeasureEnumMap, json['measurement']) ??
          IngredientMeasure.g,
      nutrition: json['nutrition'] == null
          ? const IngredientNutrition()
          : IngredientNutrition.fromJson(
              json['nutrition'] as Map<String, dynamic>),
      isOptional: json['is_optional'] ?? false,
    );

Map<String, dynamic> _$$_IngredientToJson(_$_Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': _$IngredientCategoryEnumMap[instance.category],
      'quantity': instance.quantity,
      'measurement': _$IngredientMeasureEnumMap[instance.measurement],
      'nutrition': instance.nutrition,
      'is_optional': instance.isOptional,
    };

const _$IngredientCategoryEnumMap = {
  IngredientCategory.grains: 'grains',
  IngredientCategory.grainAlernatives: 'grainAlernatives',
  IngredientCategory.pasta: 'pasta',
  IngredientCategory.oils: 'oils',
  IngredientCategory.eggs: 'eggs',
  IngredientCategory.dairy: 'dairy',
  IngredientCategory.dairyAlternative: 'dairyAlternative',
  IngredientCategory.meat: 'meat',
  IngredientCategory.meatAlternative: 'meatAlternative',
  IngredientCategory.fish: 'fish',
  IngredientCategory.vegetables: 'vegetables',
  IngredientCategory.fruit: 'fruit',
  IngredientCategory.condiments: 'condiments',
  IngredientCategory.sauces: 'sauces',
  IngredientCategory.dressings: 'dressings',
  IngredientCategory.nuts: 'nuts',
  IngredientCategory.seeds: 'seeds',
  IngredientCategory.beans: 'beans',
  IngredientCategory.spices: 'spices',
  IngredientCategory.sweeteners: 'sweeteners',
  IngredientCategory.misc: 'misc',
};

const _$IngredientMeasureEnumMap = {
  IngredientMeasure.tbsp: 'tbsp',
  IngredientMeasure.tsp: 'tsp',
  IngredientMeasure.lb: 'lb',
  IngredientMeasure.oz: 'oz',
  IngredientMeasure.cup: 'cup',
  IngredientMeasure.g: 'g',
  IngredientMeasure.mg: 'mg',
  IngredientMeasure.pinch: 'pinch',
  IngredientMeasure.item: 'item',
};
