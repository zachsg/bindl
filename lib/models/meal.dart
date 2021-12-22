import 'package:bindl/models/allergy.dart';
import 'package:bindl/models/tag.dart';
import 'package:json_annotation/json_annotation.dart';

import 'ingredient.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal {
  final int id;
  final String owner;
  final String name;
  final int servings;
  final int duration;
  @JsonKey(name: 'image_url')
  final String imageURL;
  final List<String> steps;
  final List<Ingredient> ingredients;
  final List<Tag> tags;
  final List<Allergy> allergies;

  const Meal(this.id, this.owner, this.name, this.servings, this.duration,
      this.imageURL, this.steps, this.ingredients, this.tags, this.allergies);

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}
