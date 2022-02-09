import 'package:json_annotation/json_annotation.dart';

import 'measurement.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  final String name;
  final double quantity;
  final Measurement measurement;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.measurement,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  Ingredient copyWith({
    String? name,
    double? quantity,
    Measurement? measurement,
  }) =>
      Ingredient(
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        measurement: measurement ?? this.measurement,
      );
}
