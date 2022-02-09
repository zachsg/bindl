// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealHistoryItem _$MealHistoryItemFromJson(Map<String, dynamic> json) =>
    MealHistoryItem(
      id: json['id'] as int,
      createdAt: json['created_at'] as String,
      recipeID: json['recipe_id'] as int,
      profileID: json['profile_id'] as String,
    );

Map<String, dynamic> _$MealHistoryItemToJson(MealHistoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'recipe_id': instance.recipeID,
      'profile_id': instance.profileID,
    };
