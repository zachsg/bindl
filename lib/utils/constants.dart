import 'package:bindl/shared/tags.dart';
import 'package:bindl/survey/survey_meal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final allSurveyMeals = [
  const SurveyMeal(
    name: 'Ramen',
    image: 'assets/images/ramen.jpeg',
    tags: [Tag.asian, Tag.japanese, Tag.salty],
  ),
  const SurveyMeal(
    name: 'Beef Tacos',
    image: 'assets/images/beef_tacos.jpeg',
    tags: [Tag.latin, Tag.sandwich, Tag.salty],
  ),
];
