import 'package:json_annotation/json_annotation.dart';

import 'ingredient.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal {
  const Meal(this.id, this.name, this.imageURL, this.steps, this.ingredients);

  final int id;
  final String name;
  @JsonKey(name: 'image_url')
  final String imageURL;
  final List<String> steps;
  final List<Ingredient> ingredients;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}
