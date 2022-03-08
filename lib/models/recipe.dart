import 'package:freezed_annotation/freezed_annotation.dart';

import 'allergy.dart';
import 'cuisine.dart';
import 'ingredient.dart';
import 'recipe_step.dart';
import 'recipe_tag.dart';
import 'recipe_type.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@Freezed()
class Recipe with _$Recipe {
  const factory Recipe({
    int? id,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'video_url') @Default('') String videoUrl,
    @Default([]) List<RecipeStep> steps,
    @Default([]) List<Ingredient> ingredients,
    @Default([]) List<Allergy> allergies,
    required Cuisine cuisine,
    @JsonKey(name: 'recipe_type') required RecipeType recipeType,
    @JsonKey(name: 'recipe_tags') @Default([]) List<RecipeTag> recipeTags,
    @Default(2) int servings,
    @JsonKey(name: 'cook_time') @Default(20) int cookTime,
    @JsonKey(name: 'prep_time') @Default(10) int prepTime,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
