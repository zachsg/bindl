import 'package:freezed_annotation/freezed_annotation.dart';

import 'allergy.dart';
import 'cuisine.dart';
import 'diet.dart';
import 'experience.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed()
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(name: 'updated_at') required String updatedAt,
    required String name,
    required String handle,
    @Default('') String avatar,
    @Default('') String bio,
    @Default(Experience.novice) Experience experience,
    @Default([]) List<Allergy> allergies,
    @Default([]) List<Diet> diets,
    @Default([]) List<Cuisine> cuisines,
    @Default([]) List<String> followers,
    @Default([]) List<String> following,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
