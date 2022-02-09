import 'package:json_annotation/json_annotation.dart';

part 'meal_history_item.g.dart';

@JsonSerializable()
class MealHistoryItem {
  final int id;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'recipe_id')
  final int recipeID;
  @JsonKey(name: 'profile_id')
  final String profileID;

  MealHistoryItem({
    required this.id,
    required this.createdAt,
    required this.recipeID,
    required this.profileID,
  });

  factory MealHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$MealHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$MealHistoryItemToJson(this);

  MealHistoryItem copyWith({
    int? id,
    String? createdAt,
    int? recipeID,
    String? profileID,
  }) =>
      MealHistoryItem(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        recipeID: recipeID ?? this.recipeID,
        profileID: profileID ?? this.profileID,
      );
}
