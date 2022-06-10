import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_nutrition.freezed.dart';
part 'ingredient_nutrition.g.dart';

@freezed
class IngredientNutrition with _$IngredientNutrition {
  const factory IngredientNutrition({
    @Default(0.0) double gProtein,
    @Default(0.0) double gCarb,
    @Default(0.0) double gFat,
    @Default(0.0) double calories,
  }) = _IngredientNutrition;

  factory IngredientNutrition.fromJson(Map<String, dynamic> json) =>
      _$IngredientNutritionFromJson(json);
}
