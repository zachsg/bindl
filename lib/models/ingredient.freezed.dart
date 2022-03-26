// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return _Ingredient.fromJson(json);
}

/// @nodoc
class _$IngredientTearOff {
  const _$IngredientTearOff();

  _Ingredient call(
      {required int id,
      required String name,
      required IngredientCategory category,
      double quantity = 0.0,
      IngredientMeasure measurement = IngredientMeasure.g,
      @JsonKey(name: 'preparation_method') String preparationMethod = '',
      IngredientNutrition nutrition = const IngredientNutrition(),
      @JsonKey(name: 'is_optional') dynamic isOptional = false}) {
    return _Ingredient(
      id: id,
      name: name,
      category: category,
      quantity: quantity,
      measurement: measurement,
      preparationMethod: preparationMethod,
      nutrition: nutrition,
      isOptional: isOptional,
    );
  }

  Ingredient fromJson(Map<String, Object?> json) {
    return Ingredient.fromJson(json);
  }
}

/// @nodoc
const $Ingredient = _$IngredientTearOff();

/// @nodoc
mixin _$Ingredient {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  IngredientCategory get category => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  IngredientMeasure get measurement => throw _privateConstructorUsedError;
  @JsonKey(name: 'preparation_method')
  String get preparationMethod => throw _privateConstructorUsedError;
  IngredientNutrition get nutrition => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_optional')
  dynamic get isOptional => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IngredientCopyWith<Ingredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngredientCopyWith<$Res> {
  factory $IngredientCopyWith(
          Ingredient value, $Res Function(Ingredient) then) =
      _$IngredientCopyWithImpl<$Res>;
  $Res call(
      {int id,
      String name,
      IngredientCategory category,
      double quantity,
      IngredientMeasure measurement,
      @JsonKey(name: 'preparation_method') String preparationMethod,
      IngredientNutrition nutrition,
      @JsonKey(name: 'is_optional') dynamic isOptional});

  $IngredientNutritionCopyWith<$Res> get nutrition;
}

/// @nodoc
class _$IngredientCopyWithImpl<$Res> implements $IngredientCopyWith<$Res> {
  _$IngredientCopyWithImpl(this._value, this._then);

  final Ingredient _value;
  // ignore: unused_field
  final $Res Function(Ingredient) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? category = freezed,
    Object? quantity = freezed,
    Object? measurement = freezed,
    Object? preparationMethod = freezed,
    Object? nutrition = freezed,
    Object? isOptional = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as IngredientCategory,
      quantity: quantity == freezed
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      measurement: measurement == freezed
          ? _value.measurement
          : measurement // ignore: cast_nullable_to_non_nullable
              as IngredientMeasure,
      preparationMethod: preparationMethod == freezed
          ? _value.preparationMethod
          : preparationMethod // ignore: cast_nullable_to_non_nullable
              as String,
      nutrition: nutrition == freezed
          ? _value.nutrition
          : nutrition // ignore: cast_nullable_to_non_nullable
              as IngredientNutrition,
      isOptional: isOptional == freezed
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }

  @override
  $IngredientNutritionCopyWith<$Res> get nutrition {
    return $IngredientNutritionCopyWith<$Res>(_value.nutrition, (value) {
      return _then(_value.copyWith(nutrition: value));
    });
  }
}

/// @nodoc
abstract class _$IngredientCopyWith<$Res> implements $IngredientCopyWith<$Res> {
  factory _$IngredientCopyWith(
          _Ingredient value, $Res Function(_Ingredient) then) =
      __$IngredientCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      String name,
      IngredientCategory category,
      double quantity,
      IngredientMeasure measurement,
      @JsonKey(name: 'preparation_method') String preparationMethod,
      IngredientNutrition nutrition,
      @JsonKey(name: 'is_optional') dynamic isOptional});

  @override
  $IngredientNutritionCopyWith<$Res> get nutrition;
}

/// @nodoc
class __$IngredientCopyWithImpl<$Res> extends _$IngredientCopyWithImpl<$Res>
    implements _$IngredientCopyWith<$Res> {
  __$IngredientCopyWithImpl(
      _Ingredient _value, $Res Function(_Ingredient) _then)
      : super(_value, (v) => _then(v as _Ingredient));

  @override
  _Ingredient get _value => super._value as _Ingredient;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? category = freezed,
    Object? quantity = freezed,
    Object? measurement = freezed,
    Object? preparationMethod = freezed,
    Object? nutrition = freezed,
    Object? isOptional = freezed,
  }) {
    return _then(_Ingredient(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as IngredientCategory,
      quantity: quantity == freezed
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      measurement: measurement == freezed
          ? _value.measurement
          : measurement // ignore: cast_nullable_to_non_nullable
              as IngredientMeasure,
      preparationMethod: preparationMethod == freezed
          ? _value.preparationMethod
          : preparationMethod // ignore: cast_nullable_to_non_nullable
              as String,
      nutrition: nutrition == freezed
          ? _value.nutrition
          : nutrition // ignore: cast_nullable_to_non_nullable
              as IngredientNutrition,
      isOptional: isOptional == freezed ? _value.isOptional : isOptional,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Ingredient implements _Ingredient {
  const _$_Ingredient(
      {required this.id,
      required this.name,
      required this.category,
      this.quantity = 0.0,
      this.measurement = IngredientMeasure.g,
      @JsonKey(name: 'preparation_method') this.preparationMethod = '',
      this.nutrition = const IngredientNutrition(),
      @JsonKey(name: 'is_optional') this.isOptional = false});

  factory _$_Ingredient.fromJson(Map<String, dynamic> json) =>
      _$$_IngredientFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final IngredientCategory category;
  @JsonKey()
  @override
  final double quantity;
  @JsonKey()
  @override
  final IngredientMeasure measurement;
  @override
  @JsonKey(name: 'preparation_method')
  final String preparationMethod;
  @JsonKey()
  @override
  final IngredientNutrition nutrition;
  @override
  @JsonKey(name: 'is_optional')
  final dynamic isOptional;

  @override
  String toString() {
    return 'Ingredient(id: $id, name: $name, category: $category, quantity: $quantity, measurement: $measurement, preparationMethod: $preparationMethod, nutrition: $nutrition, isOptional: $isOptional)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Ingredient &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.category, category) &&
            const DeepCollectionEquality().equals(other.quantity, quantity) &&
            const DeepCollectionEquality()
                .equals(other.measurement, measurement) &&
            const DeepCollectionEquality()
                .equals(other.preparationMethod, preparationMethod) &&
            const DeepCollectionEquality().equals(other.nutrition, nutrition) &&
            const DeepCollectionEquality()
                .equals(other.isOptional, isOptional));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(category),
      const DeepCollectionEquality().hash(quantity),
      const DeepCollectionEquality().hash(measurement),
      const DeepCollectionEquality().hash(preparationMethod),
      const DeepCollectionEquality().hash(nutrition),
      const DeepCollectionEquality().hash(isOptional));

  @JsonKey(ignore: true)
  @override
  _$IngredientCopyWith<_Ingredient> get copyWith =>
      __$IngredientCopyWithImpl<_Ingredient>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_IngredientToJson(this);
  }
}

abstract class _Ingredient implements Ingredient {
  const factory _Ingredient(
      {required int id,
      required String name,
      required IngredientCategory category,
      double quantity,
      IngredientMeasure measurement,
      @JsonKey(name: 'preparation_method') String preparationMethod,
      IngredientNutrition nutrition,
      @JsonKey(name: 'is_optional') dynamic isOptional}) = _$_Ingredient;

  factory _Ingredient.fromJson(Map<String, dynamic> json) =
      _$_Ingredient.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  IngredientCategory get category;
  @override
  double get quantity;
  @override
  IngredientMeasure get measurement;
  @override
  @JsonKey(name: 'preparation_method')
  String get preparationMethod;
  @override
  IngredientNutrition get nutrition;
  @override
  @JsonKey(name: 'is_optional')
  dynamic get isOptional;
  @override
  @JsonKey(ignore: true)
  _$IngredientCopyWith<_Ingredient> get copyWith =>
      throw _privateConstructorUsedError;
}
