import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/tag.dart';
import 'package:json_annotation/json_annotation.dart';

import 'ingredient.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal {
  final int id;
  final String name;
  @JsonKey(name: 'image_url')
  final String imageURL;
  final List<String> steps;
  final List<Ingredient> ingredients;
  final List<Tag> tags;
  final List<Allergy> allergies;

  const Meal(this.id, this.name, this.imageURL, this.steps, this.ingredients,
      this.tags, this.allergies);

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}
