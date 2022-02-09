import 'package:json_annotation/json_annotation.dart';

import 'allergy.dart';
import 'ingredient.dart';
import 'tag.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  @JsonKey(name: 'username')
  String name;
  final Map<Tag, int> tags;
  final Map<Allergy, bool> allergies;
  @JsonKey(name: 'adore_ingredients')
  final List<String> adoreIngredients;
  @JsonKey(name: 'abhor_ingredients')
  final List<String> abhorIngredients;
  @JsonKey(name: 'recipes_old_liked')
  final List<int> recipesLiked;
  @JsonKey(name: 'recipes_old_disliked')
  final List<int> recipesDisliked;
  int servings;
  @JsonKey(name: 'num_meals')
  int numMeals;
  final List<Ingredient> pantry;
  @JsonKey(name: 'has_account')
  bool hasAccount;

  User({
    required this.id,
    required this.updatedAt,
    required this.name,
    required this.tags,
    required this.allergies,
    required this.adoreIngredients,
    required this.abhorIngredients,
    required this.recipesLiked,
    required this.recipesDisliked,
    required this.servings,
    required this.numMeals,
    required this.pantry,
    this.hasAccount = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? updatedAt,
    String? name,
    Map<Tag, int>? tags,
    Map<Allergy, bool>? allergies,
    List<String>? adoreIngredients,
    List<String>? abhorIngredients,
    List<int>? recipesLiked,
    List<int>? recipesDisliked,
    int? servings,
    int? numMeals,
    List<Ingredient>? pantry,
    bool? hasAccount,
  }) =>
      User(
        id: id ?? this.id,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        tags: tags ?? this.tags,
        allergies: allergies ?? this.allergies,
        adoreIngredients: adoreIngredients ?? this.adoreIngredients,
        abhorIngredients: abhorIngredients ?? this.abhorIngredients,
        recipesLiked: recipesLiked ?? this.recipesLiked,
        recipesDisliked: recipesDisliked ?? this.recipesDisliked,
        servings: servings ?? this.servings,
        numMeals: numMeals ?? this.numMeals,
        pantry: pantry ?? this.pantry,
        hasAccount: hasAccount ?? this.hasAccount,
      );
}
