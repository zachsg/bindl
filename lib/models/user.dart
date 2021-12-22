import 'package:bindl/models/xmodels.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'username')
  final String name;
  final Map<Tag, int> tags;
  final Map<Allergy, bool> allergies;
  @JsonKey(name: 'adore_ingredients')
  final List<String> adoreIngredients;
  @JsonKey(name: 'abhor_ingredients')
  final List<String> abhorIngredients;
  final List<int> recipes;
  @JsonKey(name: 'recipes_old_liked')
  final List<int> recipesLiked;
  @JsonKey(name: 'recipes_old_disliked')
  final List<int> recipesDisliked;
  int servings;
  bool hasAccount;

  User({
    required this.name,
    required this.tags,
    required this.allergies,
    required this.adoreIngredients,
    required this.abhorIngredients,
    required this.recipes,
    required this.recipesLiked,
    required this.recipesDisliked,
    this.servings = 1,
    this.hasAccount = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  void clearRecipes() {
    recipes.clear();
  }

  void addRecipe(int id) {
    recipes.add(id);
  }
}
