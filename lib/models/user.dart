import 'package:freezed_annotation/freezed_annotation.dart';

import 'allergy.dart';
import 'appliance.dart';
import 'cuisine.dart';
import 'diet.dart';
import 'experience.dart';
import 'ingredient.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed()
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
      Cuisine.indian,
      Cuisine.caribbean,
    ])
        List<Cuisine> cuisines,
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
