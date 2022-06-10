// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
mixin _$Recipe {
  int? get id => throw _privateConstructorUsedError;
  set id(int? value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  set updatedAt(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  set ownerId(String value) => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  set name(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  set imageUrl(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  set videoUrl(String value) => throw _privateConstructorUsedError;
  List<RecipeStep> get steps => throw _privateConstructorUsedError;
  set steps(List<RecipeStep> value) => throw _privateConstructorUsedError;
  List<Ingredient> get ingredients => throw _privateConstructorUsedError;
  set ingredients(List<Ingredient> value) => throw _privateConstructorUsedError;
  List<Allergy> get allergies => throw _privateConstructorUsedError;
  set allergies(List<Allergy> value) => throw _privateConstructorUsedError;
  List<Appliance> get appliances => throw _privateConstructorUsedError;
  set appliances(List<Appliance> value) => throw _privateConstructorUsedError;
  Cuisine get cuisine => throw _privateConstructorUsedError;
  set cuisine(Cuisine value) => throw _privateConstructorUsedError;
  List<Diet> get diets => throw _privateConstructorUsedError;
  set diets(List<Diet> value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_type')
  RecipeType get recipeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_type')
  set recipeType(RecipeType value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_tags')
  List<RecipeTag> get recipeTags => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_tags')
  set recipeTags(List<RecipeTag> value) => throw _privateConstructorUsedError;
  int get servings => throw _privateConstructorUsedError;
  set servings(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'cook_time')
  int get cookTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'cook_time')
  set cookTime(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'prep_time')
  int get prepTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'prep_time')
  set prepTime(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res>;
  $Res call(
      {int? id,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'owner_id') String ownerId,
      String name,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'video_url') String videoUrl,
      List<RecipeStep> steps,
      List<Ingredient> ingredients,
      List<Allergy> allergies,
      List<Appliance> appliances,
      Cuisine cuisine,
      List<Diet> diets,
      @JsonKey(name: 'recipe_type') RecipeType recipeType,
      @JsonKey(name: 'recipe_tags') List<RecipeTag> recipeTags,
      int servings,
      @JsonKey(name: 'cook_time') int cookTime,
      @JsonKey(name: 'prep_time') int prepTime});
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res> implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  final Recipe _value;
  // ignore: unused_field
  final $Res Function(Recipe) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? updatedAt = freezed,
    Object? ownerId = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? steps = freezed,
    Object? ingredients = freezed,
    Object? allergies = freezed,
    Object? appliances = freezed,
    Object? cuisine = freezed,
    Object? diets = freezed,
    Object? recipeType = freezed,
    Object? recipeTags = freezed,
    Object? servings = freezed,
    Object? cookTime = freezed,
    Object? prepTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: ownerId == freezed
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: videoUrl == freezed
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      steps: steps == freezed
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RecipeStep>,
      ingredients: ingredients == freezed
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      allergies: allergies == freezed
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<Allergy>,
      appliances: appliances == freezed
          ? _value.appliances
          : appliances // ignore: cast_nullable_to_non_nullable
              as List<Appliance>,
      cuisine: cuisine == freezed
          ? _value.cuisine
          : cuisine // ignore: cast_nullable_to_non_nullable
              as Cuisine,
      diets: diets == freezed
          ? _value.diets
          : diets // ignore: cast_nullable_to_non_nullable
              as List<Diet>,
      recipeType: recipeType == freezed
          ? _value.recipeType
          : recipeType // ignore: cast_nullable_to_non_nullable
              as RecipeType,
      recipeTags: recipeTags == freezed
          ? _value.recipeTags
          : recipeTags // ignore: cast_nullable_to_non_nullable
              as List<RecipeTag>,
      servings: servings == freezed
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
      cookTime: cookTime == freezed
          ? _value.cookTime
          : cookTime // ignore: cast_nullable_to_non_nullable
              as int,
      prepTime: prepTime == freezed
          ? _value.prepTime
          : prepTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$_RecipeCopyWith(_$_Recipe value, $Res Function(_$_Recipe) then) =
      __$$_RecipeCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? id,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'owner_id') String ownerId,
      String name,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'video_url') String videoUrl,
      List<RecipeStep> steps,
      List<Ingredient> ingredients,
      List<Allergy> allergies,
      List<Appliance> appliances,
      Cuisine cuisine,
      List<Diet> diets,
      @JsonKey(name: 'recipe_type') RecipeType recipeType,
      @JsonKey(name: 'recipe_tags') List<RecipeTag> recipeTags,
      int servings,
      @JsonKey(name: 'cook_time') int cookTime,
      @JsonKey(name: 'prep_time') int prepTime});
}

/// @nodoc
class __$$_RecipeCopyWithImpl<$Res> extends _$RecipeCopyWithImpl<$Res>
    implements _$$_RecipeCopyWith<$Res> {
  __$$_RecipeCopyWithImpl(_$_Recipe _value, $Res Function(_$_Recipe) _then)
      : super(_value, (v) => _then(v as _$_Recipe));

  @override
  _$_Recipe get _value => super._value as _$_Recipe;

  @override
  $Res call({
    Object? id = freezed,
    Object? updatedAt = freezed,
    Object? ownerId = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? steps = freezed,
    Object? ingredients = freezed,
    Object? allergies = freezed,
    Object? appliances = freezed,
    Object? cuisine = freezed,
    Object? diets = freezed,
    Object? recipeType = freezed,
    Object? recipeTags = freezed,
    Object? servings = freezed,
    Object? cookTime = freezed,
    Object? prepTime = freezed,
  }) {
    return _then(_$_Recipe(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: ownerId == freezed
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: videoUrl == freezed
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      steps: steps == freezed
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RecipeStep>,
      ingredients: ingredients == freezed
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      allergies: allergies == freezed
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<Allergy>,
      appliances: appliances == freezed
          ? _value.appliances
          : appliances // ignore: cast_nullable_to_non_nullable
              as List<Appliance>,
      cuisine: cuisine == freezed
          ? _value.cuisine
          : cuisine // ignore: cast_nullable_to_non_nullable
              as Cuisine,
      diets: diets == freezed
          ? _value.diets
          : diets // ignore: cast_nullable_to_non_nullable
              as List<Diet>,
      recipeType: recipeType == freezed
          ? _value.recipeType
          : recipeType // ignore: cast_nullable_to_non_nullable
              as RecipeType,
      recipeTags: recipeTags == freezed
          ? _value.recipeTags
          : recipeTags // ignore: cast_nullable_to_non_nullable
              as List<RecipeTag>,
      servings: servings == freezed
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
      cookTime: cookTime == freezed
          ? _value.cookTime
          : cookTime // ignore: cast_nullable_to_non_nullable
              as int,
      prepTime: prepTime == freezed
          ? _value.prepTime
          : prepTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Recipe implements _Recipe {
  _$_Recipe(
      {this.id,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'owner_id') required this.ownerId,
      required this.name,
      @JsonKey(name: 'image_url') this.imageUrl = '',
      @JsonKey(name: 'video_url') this.videoUrl = '',
      this.steps = const [],
      this.ingredients = const [],
      this.allergies = const [],
      this.appliances = const [],
      required this.cuisine,
      this.diets = const [],
      @JsonKey(name: 'recipe_type') required this.recipeType,
      @JsonKey(name: 'recipe_tags') this.recipeTags = const [],
      this.servings = 2,
      @JsonKey(name: 'cook_time') this.cookTime = 20,
      @JsonKey(name: 'prep_time') this.prepTime = 10});

  factory _$_Recipe.fromJson(Map<String, dynamic> json) =>
      _$$_RecipeFromJson(json);

  @override
  int? id;
  @override
  @JsonKey(name: 'updated_at')
  String updatedAt;
  @override
  @JsonKey(name: 'owner_id')
  String ownerId;
  @override
  String name;
  @override
  @JsonKey(name: 'image_url')
  String imageUrl;
  @override
  @JsonKey(name: 'video_url')
  String videoUrl;
  @override
  @JsonKey()
  List<RecipeStep> steps;
  @override
  @JsonKey()
  List<Ingredient> ingredients;
  @override
  @JsonKey()
  List<Allergy> allergies;
  @override
  @JsonKey()
  List<Appliance> appliances;
  @override
  Cuisine cuisine;
  @override
  @JsonKey()
  List<Diet> diets;
  @override
  @JsonKey(name: 'recipe_type')
  RecipeType recipeType;
  @override
  @JsonKey(name: 'recipe_tags')
  List<RecipeTag> recipeTags;
  @override
  @JsonKey()
  int servings;
  @override
  @JsonKey(name: 'cook_time')
  int cookTime;
  @override
  @JsonKey(name: 'prep_time')
  int prepTime;

  @override
  String toString() {
    return 'Recipe(id: $id, updatedAt: $updatedAt, ownerId: $ownerId, name: $name, imageUrl: $imageUrl, videoUrl: $videoUrl, steps: $steps, ingredients: $ingredients, allergies: $allergies, appliances: $appliances, cuisine: $cuisine, diets: $diets, recipeType: $recipeType, recipeTags: $recipeTags, servings: $servings, cookTime: $cookTime, prepTime: $prepTime)';
  }

  @JsonKey(ignore: true)
  @override
  _$$_RecipeCopyWith<_$_Recipe> get copyWith =>
      __$$_RecipeCopyWithImpl<_$_Recipe>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RecipeToJson(this);
  }
}

abstract class _Recipe implements Recipe {
  factory _Recipe(
      {int? id,
      @JsonKey(name: 'updated_at') required String updatedAt,
      @JsonKey(name: 'owner_id') required String ownerId,
      required String name,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'video_url') String videoUrl,
      List<RecipeStep> steps,
      List<Ingredient> ingredients,
      List<Allergy> allergies,
      List<Appliance> appliances,
      required Cuisine cuisine,
      List<Diet> diets,
      @JsonKey(name: 'recipe_type') required RecipeType recipeType,
      @JsonKey(name: 'recipe_tags') List<RecipeTag> recipeTags,
      int servings,
      @JsonKey(name: 'cook_time') int cookTime,
      @JsonKey(name: 'prep_time') int prepTime}) = _$_Recipe;

  factory _Recipe.fromJson(Map<String, dynamic> json) = _$_Recipe.fromJson;

  @override
  int? get id => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'video_url')
  String get videoUrl => throw _privateConstructorUsedError;
  @override
  List<RecipeStep> get steps => throw _privateConstructorUsedError;
  @override
  List<Ingredient> get ingredients => throw _privateConstructorUsedError;
  @override
  List<Allergy> get allergies => throw _privateConstructorUsedError;
  @override
  List<Appliance> get appliances => throw _privateConstructorUsedError;
  @override
  Cuisine get cuisine => throw _privateConstructorUsedError;
  @override
  List<Diet> get diets => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'recipe_type')
  RecipeType get recipeType => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'recipe_tags')
  List<RecipeTag> get recipeTags => throw _privateConstructorUsedError;
  @override
  int get servings => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'cook_time')
  int get cookTime => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'prep_time')
  int get prepTime => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_RecipeCopyWith<_$_Recipe> get copyWith =>
      throw _privateConstructorUsedError;
}
