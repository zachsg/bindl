class Meal {
  const Meal(this.id, this.name);

  final int id;
  final String name;

  Meal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
