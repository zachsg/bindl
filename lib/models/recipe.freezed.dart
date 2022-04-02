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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
class _$RecipeTearOff {
  const _$RecipeTearOff();

  _Recipe call(
      {int? id,
      @JsonKey(name: 'updated_at') required String updatedAt,
      @JsonKey(name: 'owner_id') required String ownerId,
      required String name,
      @JsonKey(name: 'image_url') String imageUrl = '',
      @JsonKey(name: 'video_url') String videoUrl = '',
      List<RecipeStep> steps = const [],
      List<Ingredient> ingredients = const [],
      List<Allergy> allergies = const [],
      List<Appliance> appliances = const [],
      required Cuisine cuisine,
      List<Diet> diets = const [],
      @JsonKey(name: 'recipe_type') required RecipeType recipeType,
      @JsonKey(name: 'recipe_tags') List<RecipeTag> recipeTags = const [],
      int servings = 2,
      @JsonKey(name: 'cook_time') int cookTime = 20,
      @JsonKey(name: 'prep_time') int prepTime = 10}) {
    return _Recipe(
      id: id,
      updatedAt: updatedAt,
      ownerId: ownerId,
      name: name,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      steps: steps,
      ingredients: ingredients,
      allergies: allergies,
      appliances: appliances,
      cuisine: cuisine,
      diets: diets,
      recipeType: recipeType,
      recipeTags: recipeTags,
      servings: servings,
      cookTime: cookTime,
      prepTime: prepTime,
    );
  }

  Recipe fromJson(Map<String, Object?> json) {
    return Recipe.fromJson(json);
  }
}

/// @nodoc
const $Recipe = _$RecipeTearOff();

/// @nodoc
mixin _$Recipe {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String get videoUrl => throw _privateConstructorUsedError;
  List<RecipeStep> get steps => throw _privateConstructorUsedError;
  List<Ingredient> get ingredients => throw _privateConstructorUsedError;
  List<Allergy> get allergies => throw _privateConstructorUsedError;
  List<Appliance> get appliances => throw _privateConstructorUsedError;
  Cuisine get cuisine => throw _privateConstructorUsedError;
  List<Diet> get diets => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_type')
  RecipeType get recipeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_tags')
  List<RecipeTag> get recipeTags => throw _privateConstructorUsedError;
  int get servings => throw _privateConstructorUsedError;
  @JsonKey(name: 'cook_time')
  int get cookTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'prep_time')
  int get prepTime => throw _privateConstructorUsedError;

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
abstract class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) then) =
      __$RecipeCopyWithImpl<$Res>;
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
class __$RecipeCopyWithImpl<$Res> extends _$RecipeCopyWithImpl<$Res>
    implements _$RecipeCopyWith<$Res> {
  __$RecipeCopyWithImpl(_Recipe _value, $Res Function(_Recipe) _then)
      : super(_value, (v) => _then(v as _Recipe));

  @override
  _Recipe get _value => super._value as _Recipe;

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
    return _then(_Recipe(
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
  const _$_Recipe(
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
  final int? id;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  final String name;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'video_url')
  final String videoUrl;
  @JsonKey()
  @override
  final List<RecipeStep> steps;
  @JsonKey()
  @override
  final List<Ingredient> ingredients;
  @JsonKey()
  @override
  final List<Allergy> allergies;
  @JsonKey()
  @override
  final List<Appliance> appliances;
  @override
  final Cuisine cuisine;
  @JsonKey()
  @override
  final List<Diet> diets;
  @override
  @JsonKey(name: 'recipe_type')
  final RecipeType recipeType;
  @override
  @JsonKey(name: 'recipe_tags')
  final List<RecipeTag> recipeTags;
  @JsonKey()
  @override
  final int servings;
  @override
  @JsonKey(name: 'cook_time')
  final int cookTime;
  @override
  @JsonKey(name: 'prep_time')
  final int prepTime;

  @override
  String toString() {
    return 'Recipe(id: $id, updatedAt: $updatedAt, ownerId: $ownerId, name: $name, imageUrl: $imageUrl, videoUrl: $videoUrl, steps: $steps, ingredients: $ingredients, allergies: $allergies, appliances: $appliances, cuisine: $cuisine, diets: $diets, recipeType: $recipeType, recipeTags: $recipeTags, servings: $servings, cookTime: $cookTime, prepTime: $prepTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Recipe &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality().equals(other.ownerId, ownerId) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.imageUrl, imageUrl) &&
            const DeepCollectionEquality().equals(other.videoUrl, videoUrl) &&
            const DeepCollectionEquality().equals(other.steps, steps) &&
            const DeepCollectionEquality()
                .equals(other.ingredients, ingredients) &&
            const DeepCollectionEquality().equals(other.allergies, allergies) &&
            const DeepCollectionEquality()
                .equals(other.appliances, appliances) &&
            const DeepCollectionEquality().equals(other.cuisine, cuisine) &&
            const DeepCollectionEquality().equals(other.diets, diets) &&
            const DeepCollectionEquality()
                .equals(other.recipeType, recipeType) &&
            const DeepCollectionEquality()
                .equals(other.recipeTags, recipeTags) &&
            const DeepCollectionEquality().equals(other.servings, servings) &&
            const DeepCollectionEquality().equals(other.cookTime, cookTime) &&
            const DeepCollectionEquality().equals(other.prepTime, prepTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(updatedAt),
      const DeepCollectionEquality().hash(ownerId),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(imageUrl),
      const DeepCollectionEquality().hash(videoUrl),
      const DeepCollectionEquality().hash(steps),
      const DeepCollectionEquality().hash(ingredients),
      const DeepCollectionEquality().hash(allergies),
      const DeepCollectionEquality().hash(appliances),
      const DeepCollectionEquality().hash(cuisine),
      const DeepCollectionEquality().hash(diets),
      const DeepCollectionEquality().hash(recipeType),
      const DeepCollectionEquality().hash(recipeTags),
      const DeepCollectionEquality().hash(servings),
      const DeepCollectionEquality().hash(cookTime),
      const DeepCollectionEquality().hash(prepTime));

  @JsonKey(ignore: true)
  @override
  _$RecipeCopyWith<_Recipe> get copyWith =>
      __$RecipeCopyWithImpl<_Recipe>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RecipeToJson(this);
  }
}

abstract class _Recipe implements Recipe {
  const factory _Recipe(
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
  int? get id;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  String get name;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'video_url')
  String get videoUrl;
  @override
  List<RecipeStep> get steps;
  @override
  List<Ingredient> get ingredients;
  @override
  List<Allergy> get allergies;
  @override
  List<Appliance> get appliances;
  @override
  Cuisine get cuisine;
  @override
  List<Diet> get diets;
  @override
  @JsonKey(name: 'recipe_type')
  RecipeType get recipeType;
  @override
  @JsonKey(name: 'recipe_tags')
  List<RecipeTag> get recipeTags;
  @override
  int get servings;
  @override
  @JsonKey(name: 'cook_time')
  int get cookTime;
  @override
  @JsonKey(name: 'prep_time')
  int get prepTime;
  @override
  @JsonKey(ignore: true)
  _$RecipeCopyWith<_Recipe> get copyWith => throw _privateConstructorUsedError;
}
