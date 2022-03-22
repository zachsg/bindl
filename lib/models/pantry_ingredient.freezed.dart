// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pantry_ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PantryIngredient _$PantryIngredientFromJson(Map<String, dynamic> json) {
  return _PantryIngredient.fromJson(json);
}

/// @nodoc
class _$PantryIngredientTearOff {
  const _$PantryIngredientTearOff();

  _PantryIngredient call(
      {int? id,
      @JsonKey(name: 'owner_id') required String ownerId,
      @JsonKey(name: 'added_on') required String addedOn,
      @JsonKey(name: 'expires_on') required String expiresOn,
      @JsonKey(name: 'to_buy') bool toBuy = false,
      required PantryIngredient ingredient}) {
    return _PantryIngredient(
      id: id,
      ownerId: ownerId,
      addedOn: addedOn,
      expiresOn: expiresOn,
      toBuy: toBuy,
      ingredient: ingredient,
    );
  }

  PantryIngredient fromJson(Map<String, Object?> json) {
    return PantryIngredient.fromJson(json);
  }
}

/// @nodoc
const $PantryIngredient = _$PantryIngredientTearOff();

/// @nodoc
mixin _$PantryIngredient {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'added_on')
  String get addedOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_on')
  String get expiresOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_buy')
  bool get toBuy => throw _privateConstructorUsedError;
  PantryIngredient get ingredient => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PantryIngredientCopyWith<PantryIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PantryIngredientCopyWith<$Res> {
  factory $PantryIngredientCopyWith(
          PantryIngredient value, $Res Function(PantryIngredient) then) =
      _$PantryIngredientCopyWithImpl<$Res>;
  $Res call(
      {int? id,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'added_on') String addedOn,
      @JsonKey(name: 'expires_on') String expiresOn,
      @JsonKey(name: 'to_buy') bool toBuy,
      PantryIngredient ingredient});

  $PantryIngredientCopyWith<$Res> get ingredient;
}

/// @nodoc
class _$PantryIngredientCopyWithImpl<$Res>
    implements $PantryIngredientCopyWith<$Res> {
  _$PantryIngredientCopyWithImpl(this._value, this._then);

  final PantryIngredient _value;
  // ignore: unused_field
  final $Res Function(PantryIngredient) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? ownerId = freezed,
    Object? addedOn = freezed,
    Object? expiresOn = freezed,
    Object? toBuy = freezed,
    Object? ingredient = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      ownerId: ownerId == freezed
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      addedOn: addedOn == freezed
          ? _value.addedOn
          : addedOn // ignore: cast_nullable_to_non_nullable
              as String,
      expiresOn: expiresOn == freezed
          ? _value.expiresOn
          : expiresOn // ignore: cast_nullable_to_non_nullable
              as String,
      toBuy: toBuy == freezed
          ? _value.toBuy
          : toBuy // ignore: cast_nullable_to_non_nullable
              as bool,
      ingredient: ingredient == freezed
          ? _value.ingredient
          : ingredient // ignore: cast_nullable_to_non_nullable
              as PantryIngredient,
    ));
  }

  @override
  $PantryIngredientCopyWith<$Res> get ingredient {
    return $PantryIngredientCopyWith<$Res>(_value.ingredient, (value) {
      return _then(_value.copyWith(ingredient: value));
    });
  }
}

/// @nodoc
abstract class _$PantryIngredientCopyWith<$Res>
    implements $PantryIngredientCopyWith<$Res> {
  factory _$PantryIngredientCopyWith(
          _PantryIngredient value, $Res Function(_PantryIngredient) then) =
      __$PantryIngredientCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? id,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'added_on') String addedOn,
      @JsonKey(name: 'expires_on') String expiresOn,
      @JsonKey(name: 'to_buy') bool toBuy,
      PantryIngredient ingredient});

  @override
  $PantryIngredientCopyWith<$Res> get ingredient;
}

/// @nodoc
class __$PantryIngredientCopyWithImpl<$Res>
    extends _$PantryIngredientCopyWithImpl<$Res>
    implements _$PantryIngredientCopyWith<$Res> {
  __$PantryIngredientCopyWithImpl(
      _PantryIngredient _value, $Res Function(_PantryIngredient) _then)
      : super(_value, (v) => _then(v as _PantryIngredient));

  @override
  _PantryIngredient get _value => super._value as _PantryIngredient;

  @override
  $Res call({
    Object? id = freezed,
    Object? ownerId = freezed,
    Object? addedOn = freezed,
    Object? expiresOn = freezed,
    Object? toBuy = freezed,
    Object? ingredient = freezed,
  }) {
    return _then(_PantryIngredient(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      ownerId: ownerId == freezed
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      addedOn: addedOn == freezed
          ? _value.addedOn
          : addedOn // ignore: cast_nullable_to_non_nullable
              as String,
      expiresOn: expiresOn == freezed
          ? _value.expiresOn
          : expiresOn // ignore: cast_nullable_to_non_nullable
              as String,
      toBuy: toBuy == freezed
          ? _value.toBuy
          : toBuy // ignore: cast_nullable_to_non_nullable
              as bool,
      ingredient: ingredient == freezed
          ? _value.ingredient
          : ingredient // ignore: cast_nullable_to_non_nullable
              as PantryIngredient,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PantryIngredient implements _PantryIngredient {
  const _$_PantryIngredient(
      {this.id,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'added_on') required this.addedOn,
      @JsonKey(name: 'expires_on') required this.expiresOn,
      @JsonKey(name: 'to_buy') this.toBuy = false,
      required this.ingredient});

  factory _$_PantryIngredient.fromJson(Map<String, dynamic> json) =>
      _$$_PantryIngredientFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  @JsonKey(name: 'added_on')
  final String addedOn;
  @override
  @JsonKey(name: 'expires_on')
  final String expiresOn;
  @override
  @JsonKey(name: 'to_buy')
  final bool toBuy;
  @override
  final PantryIngredient ingredient;

  @override
  String toString() {
    return 'PantryIngredient(id: $id, ownerId: $ownerId, addedOn: $addedOn, expiresOn: $expiresOn, toBuy: $toBuy, ingredient: $ingredient)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PantryIngredient &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.ownerId, ownerId) &&
            const DeepCollectionEquality().equals(other.addedOn, addedOn) &&
            const DeepCollectionEquality().equals(other.expiresOn, expiresOn) &&
            const DeepCollectionEquality().equals(other.toBuy, toBuy) &&
            const DeepCollectionEquality()
                .equals(other.ingredient, ingredient));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(ownerId),
      const DeepCollectionEquality().hash(addedOn),
      const DeepCollectionEquality().hash(expiresOn),
      const DeepCollectionEquality().hash(toBuy),
      const DeepCollectionEquality().hash(ingredient));

  @JsonKey(ignore: true)
  @override
  _$PantryIngredientCopyWith<_PantryIngredient> get copyWith =>
      __$PantryIngredientCopyWithImpl<_PantryIngredient>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PantryIngredientToJson(this);
  }
}

abstract class _PantryIngredient implements PantryIngredient {
  const factory _PantryIngredient(
      {int? id,
      @JsonKey(name: 'owner_id') required String ownerId,
      @JsonKey(name: 'added_on') required String addedOn,
      @JsonKey(name: 'expires_on') required String expiresOn,
      @JsonKey(name: 'to_buy') bool toBuy,
      required PantryIngredient ingredient}) = _$_PantryIngredient;

  factory _PantryIngredient.fromJson(Map<String, dynamic> json) =
      _$_PantryIngredient.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  @JsonKey(name: 'added_on')
  String get addedOn;
  @override
  @JsonKey(name: 'expires_on')
  String get expiresOn;
  @override
  @JsonKey(name: 'to_buy')
  bool get toBuy;
  @override
  PantryIngredient get ingredient;
  @override
  @JsonKey(ignore: true)
  _$PantryIngredientCopyWith<_PantryIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}
