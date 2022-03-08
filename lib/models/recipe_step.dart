import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_step.freezed.dart';
part 'recipe_step.g.dart';

@Freezed()
class RecipeStep with _$RecipeStep {
  const factory RecipeStep({
    required String step,
    @Default('') String tip,
  }) = _RecipeStep;

  factory RecipeStep.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepFromJson(json);
}
