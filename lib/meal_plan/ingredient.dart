import 'package:bindl/meal_plan/measurement.dart';

class Ingredient {
  final String name;
  final double quantity;
  final Measurement measurement;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.measurement,
  });

  Ingredient.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        quantity = json['quantity'] + .0 as double,
        measurement = Measurement.values[json['measurement'] ?? 0];

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'measurement': measurement.index,
      };
}

List<Map<String, dynamic>> listOfIngredientsToListOfJson(
    List<Ingredient> ingredients) {
  List<Map<String, dynamic>> listOfJson = [];

  for (var ingredient in ingredients) {
    listOfJson.add(ingredient.toJson());
  }

  return listOfJson;
}

List<Ingredient> listOfJsonToListOfIngredients(
    List<Map<String, dynamic>> jsonList) {
  List<Ingredient> ingredients = [];

  for (var json in jsonList) {
    print(json);
    ingredients.add(Ingredient.fromJson(json));
  }

  return ingredients;
}
