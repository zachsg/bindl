import 'package:bodai/models/ingredient_measure.dart';
import 'package:bodai/models/ingredient_nutrition.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'ingredient_category.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required int id,
    required String name,
    required IngredientCategory category,
    @Default(0.0) double quantity,
    @Default(IngredientMeasure.g) IngredientMeasure measurement,
    @JsonKey(name: 'preparation_method') @Default('') String preparationMethod,
    @Default(IngredientNutrition()) IngredientNutrition nutrition,
    @JsonKey(name: 'is_optional') @Default(false) isOptional,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}
