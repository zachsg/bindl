// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      measurement: $enumDecode(_$MeasurementEnumMap, json['measurement']),
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'measurement': _$MeasurementEnumMap[instance.measurement],
    };

const _$MeasurementEnumMap = {
  Measurement.tbsp: 'tbsp',
  Measurement.tsp: 'tsp',
  Measurement.lb: 'lb',
  Measurement.oz: 'oz',
  Measurement.cup: 'cup',
  Measurement.g: 'g',
  Measurement.mg: 'mg',
  Measurement.pinch: 'pinch',
  Measurement.item: 'item',
};
