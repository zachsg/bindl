import 'package:bindl/models/xmodels.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  @JsonKey(name: 'username')
  String name;
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
  final List<String> pantry;
  bool hasAccount;

  User({
    required this.id,
    required this.name,
    required this.tags,
    required this.allergies,
    required this.adoreIngredients,
    required this.abhorIngredients,
    required this.recipes,
    required this.recipesLiked,
    required this.recipesDisliked,
    this.servings = 1,
    required this.pantry,
    this.hasAccount = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  void setID(String id) {
    this.id = id;
  }

  void setUsername(String username) {
    name = username;
  }

  void clearRecipes() {
    recipes.clear();
  }

  void addRecipe(int id) {
    recipes.add(id);
  }
}
