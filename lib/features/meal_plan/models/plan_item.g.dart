// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanItem _$PlanItemFromJson(Map<String, dynamic> json) => PlanItem(
      id: json['id'] as int,
      name: json['name'] as String,
      updatedAt: json['updated_at'] as String,
      plannedFor: json['planned_for'] as String,
      mealID: json['recipe_id'] as int,
    );

Map<String, dynamic> _$PlanItemToJson(PlanItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'updated_at': instance.updatedAt,
      'planned_for': instance.plannedFor,
      'recipe_id': instance.mealID,
    };
