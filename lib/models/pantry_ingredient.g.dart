// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PantryIngredient _$$_PantryIngredientFromJson(Map<String, dynamic> json) =>
    _$_PantryIngredient(
      id: json['id'] as int?,
      ownerId: json['owner_id'] as String,
      addedOn: json['added_on'] as String,
      expiresOn: json['expires_on'] as String,
      toBuy: json['to_buy'] as bool? ?? false,
      ingredient:
          Ingredient.fromJson(json['ingredient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PantryIngredientToJson(_$_PantryIngredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'added_on': instance.addedOn,
      'expires_on': instance.expiresOn,
      'to_buy': instance.toBuy,
      'ingredient': instance.ingredient,
    };
