// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

  _User call(
      {required String id,
      @JsonKey(name: 'updated_at') required String updatedAt,
      required String name,
      required String handle,
      String avatar = '',
      String bio = '',
      Experience experience = Experience.novice,
      List<Allergy> allergies = const [],
      List<Diet> diets = const [],
      List<Cuisine> cuisines = const [],
      List<String> followers = const [],
      List<String> following = const []}) {
    return _User(
      id: id,
      updatedAt: updatedAt,
      name: name,
      handle: handle,
      avatar: avatar,
      bio: bio,
      experience: experience,
      allergies: allergies,
      diets: diets,
      cuisines: cuisines,
      followers: followers,
      following: following,
    );
  }

  User fromJson(Map<String, Object?> json) {
    return User.fromJson(json);
  }
}

/// @nodoc
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get handle => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  Experience get experience => throw _privateConstructorUsedError;
  List<Allergy> get allergies => throw _privateConstructorUsedError;
  List<Diet> get diets => throw _privateConstructorUsedError;
  List<Cuisine> get cuisines => throw _privateConstructorUsedError;
  List<String> get followers => throw _privateConstructorUsedError;
  List<String> get following => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String id,
      @JsonKey(name: 'updated_at') String updatedAt,
      String name,
      String handle,
      String avatar,
      String bio,
      Experience experience,
      List<Allergy> allergies,
      List<Diet> diets,
      List<Cuisine> cuisines,
      List<String> followers,
      List<String> following});
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? updatedAt = freezed,
    Object? name = freezed,
    Object? handle = freezed,
    Object? avatar = freezed,
    Object? bio = freezed,
    Object? experience = freezed,
    Object? allergies = freezed,
    Object? diets = freezed,
    Object? cuisines = freezed,
    Object? followers = freezed,
    Object? following = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      handle: handle == freezed
          ? _value.handle
          : handle // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: avatar == freezed
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      bio: bio == freezed
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      experience: experience == freezed
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as Experience,
      allergies: allergies == freezed
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<Allergy>,
      diets: diets == freezed
          ? _value.diets
          : diets // ignore: cast_nullable_to_non_nullable
              as List<Diet>,
      cuisines: cuisines == freezed
          ? _value.cuisines
          : cuisines // ignore: cast_nullable_to_non_nullable
              as List<Cuisine>,
      followers: followers == freezed
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      following: following == freezed
          ? _value.following
          : following // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      @JsonKey(name: 'updated_at') String updatedAt,
      String name,
      String handle,
      String avatar,
      String bio,
      Experience experience,
      List<Allergy> allergies,
      List<Diet> diets,
      List<Cuisine> cuisines,
      List<String> followers,
      List<String> following});
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object? id = freezed,
    Object? updatedAt = freezed,
    Object? name = freezed,
    Object? handle = freezed,
    Object? avatar = freezed,
    Object? bio = freezed,
    Object? experience = freezed,
    Object? allergies = freezed,
    Object? diets = freezed,
    Object? cuisines = freezed,
    Object? followers = freezed,
    Object? following = freezed,
  }) {
    return _then(_User(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      handle: handle == freezed
          ? _value.handle
          : handle // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: avatar == freezed
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      bio: bio == freezed
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      experience: experience == freezed
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as Experience,
      allergies: allergies == freezed
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<Allergy>,
      diets: diets == freezed
          ? _value.diets
          : diets // ignore: cast_nullable_to_non_nullable
              as List<Diet>,
      cuisines: cuisines == freezed
          ? _value.cuisines
          : cuisines // ignore: cast_nullable_to_non_nullable
              as List<Cuisine>,
      followers: followers == freezed
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      following: following == freezed
          ? _value.following
          : following // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User implements _User {
  const _$_User(
      {required this.id,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      required this.name,
      required this.handle,
      this.avatar = '',
      this.bio = '',
      this.experience = Experience.novice,
      this.allergies = const [],
      this.diets = const [],
      this.cuisines = const [],
      this.followers = const [],
      this.following = const []});

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  final String name;
  @override
  final String handle;
  @JsonKey()
  @override
  final String avatar;
  @JsonKey()
  @override
  final String bio;
  @JsonKey()
  @override
  final Experience experience;
  @JsonKey()
  @override
  final List<Allergy> allergies;
  @JsonKey()
  @override
  final List<Diet> diets;
  @JsonKey()
  @override
  final List<Cuisine> cuisines;
  @JsonKey()
  @override
  final List<String> followers;
  @JsonKey()
  @override
  final List<String> following;

  @override
  String toString() {
    return 'User(id: $id, updatedAt: $updatedAt, name: $name, handle: $handle, avatar: $avatar, bio: $bio, experience: $experience, allergies: $allergies, diets: $diets, cuisines: $cuisines, followers: $followers, following: $following)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _User &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.handle, handle) &&
            const DeepCollectionEquality().equals(other.avatar, avatar) &&
            const DeepCollectionEquality().equals(other.bio, bio) &&
            const DeepCollectionEquality()
                .equals(other.experience, experience) &&
            const DeepCollectionEquality().equals(other.allergies, allergies) &&
            const DeepCollectionEquality().equals(other.diets, diets) &&
            const DeepCollectionEquality().equals(other.cuisines, cuisines) &&
            const DeepCollectionEquality().equals(other.followers, followers) &&
            const DeepCollectionEquality().equals(other.following, following));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(updatedAt),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(handle),
      const DeepCollectionEquality().hash(avatar),
      const DeepCollectionEquality().hash(bio),
      const DeepCollectionEquality().hash(experience),
      const DeepCollectionEquality().hash(allergies),
      const DeepCollectionEquality().hash(diets),
      const DeepCollectionEquality().hash(cuisines),
      const DeepCollectionEquality().hash(followers),
      const DeepCollectionEquality().hash(following));

  @JsonKey(ignore: true)
  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(this);
  }
}

abstract class _User implements User {
  const factory _User(
      {required String id,
      @JsonKey(name: 'updated_at') required String updatedAt,
      required String name,
      required String handle,
      String avatar,
      String bio,
      Experience experience,
      List<Allergy> allergies,
      List<Diet> diets,
      List<Cuisine> cuisines,
      List<String> followers,
      List<String> following}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  String get name;
  @override
  String get handle;
  @override
  String get avatar;
  @override
  String get bio;
  @override
  Experience get experience;
  @override
  List<Allergy> get allergies;
  @override
  List<Diet> get diets;
  @override
  List<Cuisine> get cuisines;
  @override
  List<String> get followers;
  @override
  List<String> get following;
  @override
  @JsonKey(ignore: true)
  _$UserCopyWith<_User> get copyWith => throw _privateConstructorUsedError;
}
