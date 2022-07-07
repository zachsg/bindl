// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ingredient_nutrition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

IngredientNutrition _$IngredientNutritionFromJson(Map<String, dynamic> json) {
  return _IngredientNutrition.fromJson(json);
}

/// @nodoc
mixin _$IngredientNutrition {
  double get gProtein => throw _privateConstructorUsedError;
  double get gCarb => throw _privateConstructorUsedError;
  double get gFat => throw _privateConstructorUsedError;
  double get calories => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IngredientNutritionCopyWith<IngredientNutrition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngredientNutritionCopyWith<$Res> {
  factory $IngredientNutritionCopyWith(
          IngredientNutrition value, $Res Function(IngredientNutrition) then) =
      _$IngredientNutritionCopyWithImpl<$Res>;
  $Res call({double gProtein, double gCarb, double gFat, double calories});
}

/// @nodoc
class _$IngredientNutritionCopyWithImpl<$Res>
    implements $IngredientNutritionCopyWith<$Res> {
  _$IngredientNutritionCopyWithImpl(this._value, this._then);

  final IngredientNutrition _value;
  // ignore: unused_field
  final $Res Function(IngredientNutrition) _then;

  @override
  $Res call({
    Object? gProtein = freezed,
    Object? gCarb = freezed,
    Object? gFat = freezed,
    Object? calories = freezed,
  }) {
    return _then(_value.copyWith(
      gProtein: gProtein == freezed
          ? _value.gProtein
          : gProtein // ignore: cast_nullable_to_non_nullable
              as double,
      gCarb: gCarb == freezed
          ? _value.gCarb
          : gCarb // ignore: cast_nullable_to_non_nullable
              as double,
      gFat: gFat == freezed
          ? _value.gFat
          : gFat // ignore: cast_nullable_to_non_nullable
              as double,
      calories: calories == freezed
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_IngredientNutritionCopyWith<$Res>
    implements $IngredientNutritionCopyWith<$Res> {
  factory _$$_IngredientNutritionCopyWith(_$_IngredientNutrition value,
          $Res Function(_$_IngredientNutrition) then) =
      __$$_IngredientNutritionCopyWithImpl<$Res>;
  @override
  $Res call({double gProtein, double gCarb, double gFat, double calories});
}

/// @nodoc
class __$$_IngredientNutritionCopyWithImpl<$Res>
    extends _$IngredientNutritionCopyWithImpl<$Res>
    implements _$$_IngredientNutritionCopyWith<$Res> {
  __$$_IngredientNutritionCopyWithImpl(_$_IngredientNutrition _value,
      $Res Function(_$_IngredientNutrition) _then)
      : super(_value, (v) => _then(v as _$_IngredientNutrition));

  @override
  _$_IngredientNutrition get _value => super._value as _$_IngredientNutrition;

  @override
  $Res call({
    Object? gProtein = freezed,
    Object? gCarb = freezed,
    Object? gFat = freezed,
    Object? calories = freezed,
  }) {
    return _then(_$_IngredientNutrition(
      gProtein: gProtein == freezed
          ? _value.gProtein
          : gProtein // ignore: cast_nullable_to_non_nullable
              as double,
      gCarb: gCarb == freezed
          ? _value.gCarb
          : gCarb // ignore: cast_nullable_to_non_nullable
              as double,
      gFat: gFat == freezed
          ? _value.gFat
          : gFat // ignore: cast_nullable_to_non_nullable
              as double,
      calories: calories == freezed
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_IngredientNutrition implements _IngredientNutrition {
  const _$_IngredientNutrition(
      {this.gProtein = 0.0,
      this.gCarb = 0.0,
      this.gFat = 0.0,
      this.calories = 0.0});

  factory _$_IngredientNutrition.fromJson(Map<String, dynamic> json) =>
      _$$_IngredientNutritionFromJson(json);

  @override
  @JsonKey()
  final double gProtein;
  @override
  @JsonKey()
  final double gCarb;
  @override
  @JsonKey()
  final double gFat;
  @override
  @JsonKey()
  final double calories;

  @override
  String toString() {
    return 'IngredientNutrition(gProtein: $gProtein, gCarb: $gCarb, gFat: $gFat, calories: $calories)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_IngredientNutrition &&
            const DeepCollectionEquality().equals(other.gProtein, gProtein) &&
            const DeepCollectionEquality().equals(other.gCarb, gCarb) &&
            const DeepCollectionEquality().equals(other.gFat, gFat) &&
            const DeepCollectionEquality().equals(other.calories, calories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(gProtein),
      const DeepCollectionEquality().hash(gCarb),
      const DeepCollectionEquality().hash(gFat),
      const DeepCollectionEquality().hash(calories));

  @JsonKey(ignore: true)
  @override
  _$$_IngredientNutritionCopyWith<_$_IngredientNutrition> get copyWith =>
      __$$_IngredientNutritionCopyWithImpl<_$_IngredientNutrition>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_IngredientNutritionToJson(this);
  }
}

abstract class _IngredientNutrition implements IngredientNutrition {
  const factory _IngredientNutrition(
      {final double gProtein,
      final double gCarb,
      final double gFat,
      final double calories}) = _$_IngredientNutrition;

  factory _IngredientNutrition.fromJson(Map<String, dynamic> json) =
      _$_IngredientNutrition.fromJson;

  @override
  double get gProtein;
  @override
  double get gCarb;
  @override
  double get gFat;
  @override
  double get calories;
  @override
  @JsonKey(ignore: true)
  _$$_IngredientNutritionCopyWith<_$_IngredientNutrition> get copyWith =>
      throw _privateConstructorUsedError;
}
