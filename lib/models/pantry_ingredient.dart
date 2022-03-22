import 'package:freezed_annotation/freezed_annotation.dart';

part 'pantry_ingredient.freezed.dart';
part 'pantry_ingredient.g.dart';

@Freezed()
class PantryIngredient with _$PantryIngredient {
  const factory PantryIngredient({
    int? id,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'added_on') required String addedOn,
    @JsonKey(name: 'expires_on') required String expiresOn,
    @JsonKey(name: 'to_buy') @Default(false) bool toBuy,
    required PantryIngredient ingredient,
  }) = _PantryIngredient;

  factory PantryIngredient.fromJson(Map<String, dynamic> json) =>
      _$PantryIngredientFromJson(json);
}
