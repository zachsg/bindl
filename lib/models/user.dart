import 'package:bodai/models/xmodels.dart';
import 'package:json_annotation/json_annotation.dart';

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
  final List<int> recipes;
  @JsonKey(name: 'recipes_old_liked')
  final List<int> recipesLiked;
  @JsonKey(name: 'recipes_old_disliked')
  final List<int> recipesDisliked;
  int servings;
  @JsonKey(name: 'num_meals')
  int numMeals;
  final List<Ingredient> pantry;
  bool hasAccount;

  User({
    required this.id,
    required this.updatedAt,
    required this.name,
    required this.tags,
    required this.allergies,
    required this.adoreIngredients,
    required this.abhorIngredients,
    required this.recipes,
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
    List<int>? recipes,
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
        recipes: recipes ?? this.recipes,
        recipesLiked: recipesLiked ?? this.recipesLiked,
        recipesDisliked: recipesDisliked ?? this.recipesDisliked,
        servings: servings ?? this.servings,
        numMeals: numMeals ?? this.numMeals,
        pantry: pantry ?? this.pantry,
        hasAccount: hasAccount ?? this.hasAccount,
      );

  void setID(String id) {
    this.id = id;
  }

  void setUpdatedAt(DateTime dateTime) {
    updatedAt = dateTime.toIso8601String();
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
