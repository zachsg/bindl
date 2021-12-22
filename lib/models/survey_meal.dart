import 'package:bindl/models/xmodels.dart';

class SurveyMeal {
  final String name;
  final String image;
  final List<Tag> tags;

  const SurveyMeal({
    required this.name,
    required this.image,
    required this.tags,
  });
}