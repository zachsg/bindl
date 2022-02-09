import 'package:json_annotation/json_annotation.dart';

part 'plan_item.g.dart';

@JsonSerializable()
class PlanItem {
  final int id;
  final String name;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'planned_for')
  final String plannedFor;
  @JsonKey(name: 'recipe_id')
  final int mealID;

  PlanItem({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.plannedFor,
    required this.mealID,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) =>
      _$PlanItemFromJson(json);

  Map<String, dynamic> toJson() => _$PlanItemToJson(this);

  PlanItem copyWith({
    int? id,
    String? name,
    String? updatedAt,
    String? plannedFor,
    int? mealID,
  }) =>
      PlanItem(
        id: id ?? this.id,
        name: name ?? this.name,
        updatedAt: updatedAt ?? this.updatedAt,
        plannedFor: plannedFor ?? this.plannedFor,
        mealID: mealID ?? this.mealID,
      );
}
