import 'ingredient.dart';

class Meal {
  const Meal(this.id, this.name, this.imageURL, this.steps, this.ingredients);

  final int id;
  final String name;
  final String imageURL;
  final List<String> steps;
  final List<Ingredient> ingredients;

  Meal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imageURL = json['image_url'],
        steps = List<String>.from(json['steps']),
        ingredients = listOfJsonToListOfIngredients(
          List<Map<String, dynamic>>.from(json['ingredients']),
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageURL,
        'steps': steps,
        'ingredients': listOfIngredientsToListOfJson(ingredients),
      };
}
