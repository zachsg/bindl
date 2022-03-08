// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_nutrition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_IngredientNutrition _$$_IngredientNutritionFromJson(
        Map<String, dynamic> json) =>
    _$_IngredientNutrition(
      gProtein: (json['gProtein'] as num?)?.toDouble() ?? 0.0,
      gCarb: (json['gCarb'] as num?)?.toDouble() ?? 0.0,
      gFat: (json['gFat'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$_IngredientNutritionToJson(
        _$_IngredientNutrition instance) =>
    <String, dynamic>{
      'gProtein': instance.gProtein,
      'gCarb': instance.gCarb,
      'gFat': instance.gFat,
      'calories': instance.calories,
    };
