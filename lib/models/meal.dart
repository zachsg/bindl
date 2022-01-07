import 'package:bodai/models/xmodels.dart';
import 'package:json_annotation/json_annotation.dart';

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
  final List<Comment> comments;

  const Meal({
    required this.id,
    required this.owner,
    required this.name,
    required this.servings,
    required this.duration,
    required this.imageURL,
    required this.steps,
    required this.ingredients,
    required this.tags,
    required this.allergies,
    required this.comments,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);

  Meal copyWith({
    int? id,
    String? owner,
    String? name,
    int? servings,
    int? duration,
    String? imageURL,
    List<String>? steps,
    List<Ingredient>? ingredients,
    List<Tag>? tags,
    List<Allergy>? allergies,
    List<Comment>? comments,
  }) =>
      Meal(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        name: name ?? this.name,
        servings: servings ?? this.servings,
        duration: duration ?? this.duration,
        imageURL: imageURL ?? this.imageURL,
        steps: steps ?? this.steps,
        ingredients: ingredients ?? this.ingredients,
        tags: tags ?? this.tags,
        allergies: allergies ?? this.allergies,
        comments: comments ?? this.comments,
      );
}
