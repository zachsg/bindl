import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';

@JsonSerializable()
class Plan {
  final int id;
  final String name;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'planned_for')
  final String plannedFor;
  @JsonKey(name: 'recipe_id')
  final int mealID;

  Plan({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.plannedFor,
    required this.mealID,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  Map<String, dynamic> toJson() => _$PlanToJson(this);

  Plan copyWith({
    int? id,
    String? name,
    String? updatedAt,
    String? plannedFor,
    int? mealID,
  }) =>
      Plan(
        id: id ?? this.id,
        name: name ?? this.name,
        updatedAt: updatedAt ?? this.updatedAt,
        plannedFor: plannedFor ?? this.plannedFor,
        mealID: mealID ?? this.mealID,
      );
}
