import 'package:bindl/models/xmodels.dart';
import 'package:json_annotation/json_annotation.dart';

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
}
