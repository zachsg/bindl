import 'package:bodai/shared_models/xmodels.dart';

class SurveyMeal {
  final String name;
  final String image;
  final List<Tag> tags;

  const SurveyMeal({
    required this.name,
    required this.image,
    required this.tags,
  });

  SurveyMeal copyWith({
    String? name,
    String? image,
    List<Tag>? tags,
  }) =>
      SurveyMeal(
        name: name ?? this.name,
        image: image ?? this.image,
        tags: tags ?? this.tags,
      );
}
