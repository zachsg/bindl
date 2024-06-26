// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'allergy.dart';
import 'appliance.dart';
import 'cuisine.dart';
import 'diet.dart';
import 'experience.dart';
import 'ingredient.dart';
import 'recipe_tag.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(name: 'updated_at')
        required String updatedAt,
    required String name,
    required String handle,
    @Default('')
        String avatar,
    @Default('')
        String bio,
    @Default(Experience.novice)
        Experience experience,
    @Default([])
        List<Allergy> allergies,
    @Default([
      Appliance.oven,
      Appliance.stovetop,
      Appliance.airFryer,
      Appliance.instantPot,
      Appliance.blender,
      Appliance.mortarAndPestle,
    ])
        List<Appliance> appliances,
    @Default([
      Diet.keto,
      Diet.omnivore,
      Diet.paleo,
      Diet.vegan,
      Diet.vegetarian,
    ])
        List<Diet> diets,
    @Default([
      Cuisine.american,
      Cuisine.mexican,
      Cuisine.spanish,
      Cuisine.japanese,
      Cuisine.thai,
      Cuisine.chinese,
      Cuisine.korean,
      Cuisine.german,
      Cuisine.italian,
      Cuisine.french,
      Cuisine.mediterranean,
      Cuisine.indian,
      Cuisine.turkish,
      Cuisine.caribbean,
    ])
        List<Cuisine> cuisines,
    @JsonKey(name: 'tags')
    @Default({})
        Map<RecipeTag, int> tags,
    @Default([])
    @JsonKey(name: 'adore_ingredients')
        List<Ingredient> adoreIngredients,
    @Default([])
    @JsonKey(name: 'abhor_ingredients')
        List<Ingredient> abhorIngredients,
    @Default([])
        List<String> followers,
    @Default([])
        List<String> following,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
