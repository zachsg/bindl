import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/tag.dart';

class User {
  final String name;
  final Map<Tag, int> tags;
  final Map<Allergy, bool> allergies;
  final List<String> adoreIngredients;
  final List<String> abhorIngredients;
  final List<int> recipes;
  bool hasAccount;

  User({
    required this.name,
    required this.tags,
    required this.allergies,
    required this.adoreIngredients,
    required this.abhorIngredients,
    required this.recipes,
    this.hasAccount = false,
  });
}
