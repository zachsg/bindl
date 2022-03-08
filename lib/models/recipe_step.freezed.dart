// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'recipe_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RecipeStep _$RecipeStepFromJson(Map<String, dynamic> json) {
  return _RecipeStep.fromJson(json);
}

/// @nodoc
class _$RecipeStepTearOff {
  const _$RecipeStepTearOff();

  _RecipeStep call({required String step, String tip = ''}) {
    return _RecipeStep(
      step: step,
      tip: tip,
    );
  }

  RecipeStep fromJson(Map<String, Object?> json) {
    return RecipeStep.fromJson(json);
  }
}

/// @nodoc
const $RecipeStep = _$RecipeStepTearOff();

/// @nodoc
mixin _$RecipeStep {
  String get step => throw _privateConstructorUsedError;
  String get tip => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecipeStepCopyWith<RecipeStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeStepCopyWith<$Res> {
  factory $RecipeStepCopyWith(
          RecipeStep value, $Res Function(RecipeStep) then) =
      _$RecipeStepCopyWithImpl<$Res>;
  $Res call({String step, String tip});
}

/// @nodoc
class _$RecipeStepCopyWithImpl<$Res> implements $RecipeStepCopyWith<$Res> {
  _$RecipeStepCopyWithImpl(this._value, this._then);

  final RecipeStep _value;
  // ignore: unused_field
  final $Res Function(RecipeStep) _then;

  @override
  $Res call({
    Object? step = freezed,
    Object? tip = freezed,
  }) {
    return _then(_value.copyWith(
      step: step == freezed
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as String,
      tip: tip == freezed
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$RecipeStepCopyWith<$Res> implements $RecipeStepCopyWith<$Res> {
  factory _$RecipeStepCopyWith(
          _RecipeStep value, $Res Function(_RecipeStep) then) =
      __$RecipeStepCopyWithImpl<$Res>;
  @override
  $Res call({String step, String tip});
}

/// @nodoc
class __$RecipeStepCopyWithImpl<$Res> extends _$RecipeStepCopyWithImpl<$Res>
    implements _$RecipeStepCopyWith<$Res> {
  __$RecipeStepCopyWithImpl(
      _RecipeStep _value, $Res Function(_RecipeStep) _then)
      : super(_value, (v) => _then(v as _RecipeStep));

  @override
  _RecipeStep get _value => super._value as _RecipeStep;

  @override
  $Res call({
    Object? step = freezed,
    Object? tip = freezed,
  }) {
    return _then(_RecipeStep(
      step: step == freezed
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as String,
      tip: tip == freezed
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RecipeStep implements _RecipeStep {
  const _$_RecipeStep({required this.step, this.tip = ''});

  factory _$_RecipeStep.fromJson(Map<String, dynamic> json) =>
      _$$_RecipeStepFromJson(json);

  @override
  final String step;
  @JsonKey()
  @override
  final String tip;

  @override
  String toString() {
    return 'RecipeStep(step: $step, tip: $tip)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecipeStep &&
            const DeepCollectionEquality().equals(other.step, step) &&
            const DeepCollectionEquality().equals(other.tip, tip));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(step),
      const DeepCollectionEquality().hash(tip));

  @JsonKey(ignore: true)
  @override
  _$RecipeStepCopyWith<_RecipeStep> get copyWith =>
      __$RecipeStepCopyWithImpl<_RecipeStep>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RecipeStepToJson(this);
  }
}

abstract class _RecipeStep implements RecipeStep {
  const factory _RecipeStep({required String step, String tip}) = _$_RecipeStep;

  factory _RecipeStep.fromJson(Map<String, dynamic> json) =
      _$_RecipeStep.fromJson;

  @override
  String get step;
  @override
  String get tip;
  @override
  @JsonKey(ignore: true)
  _$RecipeStepCopyWith<_RecipeStep> get copyWith =>
      throw _privateConstructorUsedError;
}
