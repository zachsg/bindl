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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

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
  List<Appliance> get appliances => throw _privateConstructorUsedError;
  List<Diet> get diets => throw _privateConstructorUsedError;
  List<Cuisine> get cuisines => throw _privateConstructorUsedError;
  @JsonKey(name: 'tags')
  Map<RecipeTag, int> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'adore_ingredients')
  List<Ingredient> get adoreIngredients => throw _privateConstructorUsedError;
  @JsonKey(name: 'abhor_ingredients')
  List<Ingredient> get abhorIngredients => throw _privateConstructorUsedError;
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
      List<Appliance> appliances,
      List<Diet> diets,
      List<Cuisine> cuisines,
      @JsonKey(name: 'tags') Map<RecipeTag, int> tags,
      @JsonKey(name: 'adore_ingredients') List<Ingredient> adoreIngredients,
      @JsonKey(name: 'abhor_ingredients') List<Ingredient> abhorIngredients,
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
    Object? appliances = freezed,
    Object? diets = freezed,
    Object? cuisines = freezed,
    Object? tags = freezed,
    Object? adoreIngredients = freezed,
    Object? abhorIngredients = freezed,
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
      appliances: appliances == freezed
          ? _value.appliances
          : appliances // ignore: cast_nullable_to_non_nullable
              as List<Appliance>,
      diets: diets == freezed
          ? _value.diets
          : diets // ignore: cast_nullable_to_non_nullable
              as List<Diet>,
      cuisines: cuisines == freezed
          ? _value.cuisines
          : cuisines // ignore: cast_nullable_to_non_nullable
              as List<Cuisine>,
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<RecipeTag, int>,
      adoreIngredients: adoreIngredients == freezed
          ? _value.adoreIngredients
          : adoreIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      abhorIngredients: abhorIngredients == freezed
          ? _value.abhorIngredients
          : abhorIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
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
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
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
      List<Appliance> appliances,
      List<Diet> diets,
      List<Cuisine> cuisines,
      @JsonKey(name: 'tags') Map<RecipeTag, int> tags,
      @JsonKey(name: 'adore_ingredients') List<Ingredient> adoreIngredients,
      @JsonKey(name: 'abhor_ingredients') List<Ingredient> abhorIngredients,
      List<String> followers,
      List<String> following});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, (v) => _then(v as _$_User));

  @override
  _$_User get _value => super._value as _$_User;

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
    Object? appliances = freezed,
    Object? diets = freezed,
    Object? cuisines = freezed,
    Object? tags = freezed,
    Object? adoreIngredients = freezed,
    Object? abhorIngredients = freezed,
    Object? followers = freezed,
    Object? following = freezed,
  }) {
    return _then(_$_User(
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
          ? _value._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<Allergy>,
      appliances: appliances == freezed
          ? _value._appliances
          : appliances // ignore: cast_nullable_to_non_nullable
              as List<Appliance>,
      diets: diets == freezed
          ? _value._diets
          : diets // ignore: cast_nullable_to_non_nullable
              as List<Diet>,
      cuisines: cuisines == freezed
          ? _value._cuisines
          : cuisines // ignore: cast_nullable_to_non_nullable
              as List<Cuisine>,
      tags: tags == freezed
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<RecipeTag, int>,
      adoreIngredients: adoreIngredients == freezed
          ? _value._adoreIngredients
          : adoreIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      abhorIngredients: abhorIngredients == freezed
          ? _value._abhorIngredients
          : abhorIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      followers: followers == freezed
          ? _value._followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      following: following == freezed
          ? _value._following
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
      final List<Allergy> allergies = const [],
      final List<Appliance> appliances = const [
        Appliance.oven,
        Appliance.stovetop,
        Appliance.airFryer,
        Appliance.instantPot,
        Appliance.blender
      ],
      final List<Diet> diets = const [
        Diet.keto,
        Diet.omnivore,
        Diet.paleo,
        Diet.vegan,
        Diet.vegetarian
      ],
      final List<Cuisine> cuisines = const [
        Cuisine.american,
        Cuisine.mexican,
        Cuisine.spanish,
        Cuisine.japanese,
        Cuisine.thai,
        Cuisine.chinese,
        Cuisine.korean,
        Cuisine.german,
        Cuisine.italian,
        Cuisine.french,
        Cuisine.indian,
        Cuisine.caribbean
      ],
      @JsonKey(name: 'tags') final Map<RecipeTag, int> tags = const {},
      @JsonKey(name: 'adore_ingredients') final List<Ingredient> adoreIngredients =
          const [],
      @JsonKey(name: 'abhor_ingredients') final List<Ingredient> abhorIngredients =
          const [],
      final List<String> followers = const [],
      final List<String> following = const []})
      : _allergies = allergies,
        _appliances = appliances,
        _diets = diets,
        _cuisines = cuisines,
        _tags = tags,
        _adoreIngredients = adoreIngredients,
        _abhorIngredients = abhorIngredients,
        _followers = followers,
        _following = following;

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
  @override
  @JsonKey()
  final String avatar;
  @override
  @JsonKey()
  final String bio;
  @override
  @JsonKey()
  final Experience experience;
  final List<Allergy> _allergies;
  @override
  @JsonKey()
  List<Allergy> get allergies {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  final List<Appliance> _appliances;
  @override
  @JsonKey()
  List<Appliance> get appliances {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appliances);
  }

  final List<Diet> _diets;
  @override
  @JsonKey()
  List<Diet> get diets {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diets);
  }

  final List<Cuisine> _cuisines;
  @override
  @JsonKey()
  List<Cuisine> get cuisines {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cuisines);
  }

  final Map<RecipeTag, int> _tags;
  @override
  @JsonKey(name: 'tags')
  Map<RecipeTag, int> get tags {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

  final List<Ingredient> _adoreIngredients;
  @override
  @JsonKey(name: 'adore_ingredients')
  List<Ingredient> get adoreIngredients {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adoreIngredients);
  }

  final List<Ingredient> _abhorIngredients;
  @override
  @JsonKey(name: 'abhor_ingredients')
  List<Ingredient> get abhorIngredients {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_abhorIngredients);
  }

  final List<String> _followers;
  @override
  @JsonKey()
  List<String> get followers {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followers);
  }

  final List<String> _following;
  @override
  @JsonKey()
  List<String> get following {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_following);
  }

  @override
  String toString() {
    return 'User(id: $id, updatedAt: $updatedAt, name: $name, handle: $handle, avatar: $avatar, bio: $bio, experience: $experience, allergies: $allergies, appliances: $appliances, diets: $diets, cuisines: $cuisines, tags: $tags, adoreIngredients: $adoreIngredients, abhorIngredients: $abhorIngredients, followers: $followers, following: $following)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.handle, handle) &&
            const DeepCollectionEquality().equals(other.avatar, avatar) &&
            const DeepCollectionEquality().equals(other.bio, bio) &&
            const DeepCollectionEquality()
                .equals(other.experience, experience) &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies) &&
            const DeepCollectionEquality()
                .equals(other._appliances, _appliances) &&
            const DeepCollectionEquality().equals(other._diets, _diets) &&
            const DeepCollectionEquality().equals(other._cuisines, _cuisines) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._adoreIngredients, _adoreIngredients) &&
            const DeepCollectionEquality()
                .equals(other._abhorIngredients, _abhorIngredients) &&
            const DeepCollectionEquality()
                .equals(other._followers, _followers) &&
            const DeepCollectionEquality()
                .equals(other._following, _following));
  }

  @JsonKey(ignore: true)
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
      const DeepCollectionEquality().hash(_allergies),
      const DeepCollectionEquality().hash(_appliances),
      const DeepCollectionEquality().hash(_diets),
      const DeepCollectionEquality().hash(_cuisines),
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_adoreIngredients),
      const DeepCollectionEquality().hash(_abhorIngredients),
      const DeepCollectionEquality().hash(_followers),
      const DeepCollectionEquality().hash(_following));

  @JsonKey(ignore: true)
  @override
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(this);
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      @JsonKey(name: 'updated_at')
          required final String updatedAt,
      required final String name,
      required final String handle,
      final String avatar,
      final String bio,
      final Experience experience,
      final List<Allergy> allergies,
      final List<Appliance> appliances,
      final List<Diet> diets,
      final List<Cuisine> cuisines,
      @JsonKey(name: 'tags')
          final Map<RecipeTag, int> tags,
      @JsonKey(name: 'adore_ingredients')
          final List<Ingredient> adoreIngredients,
      @JsonKey(name: 'abhor_ingredients')
          final List<Ingredient> abhorIngredients,
      final List<String> followers,
      final List<String> following}) = _$_User;

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
  List<Appliance> get appliances;
  @override
  List<Diet> get diets;
  @override
  List<Cuisine> get cuisines;
  @override
  @JsonKey(name: 'tags')
  Map<RecipeTag, int> get tags;
  @override
  @JsonKey(name: 'adore_ingredients')
  List<Ingredient> get adoreIngredients;
  @override
  @JsonKey(name: 'abhor_ingredients')
  List<Ingredient> get abhorIngredients;
  @override
  List<String> get followers;
  @override
  List<String> get following;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
