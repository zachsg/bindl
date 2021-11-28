import 'package:bindl/shared/tag.dart';
import 'package:bindl/survey/survey_meal.dart';

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

// final allergies = {
//   Allergy.soy: false,
//   Allergy.gluten: false,
//   Allergy.dairy: false,
//   Allergy.egg: false,
//   Allergy.shellfish: false,
//   Allergy.sesame: false,
//   Allergy.treeNuts: false,
//   Allergy.peanuts: false,
// };
