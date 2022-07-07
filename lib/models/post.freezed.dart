// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_id')
  int? get recipeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String get videoUrl => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<int> get comments => throw _privateConstructorUsedError;
  List<String> get likes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res>;
  $Res call(
      {int? id,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'recipe_id') int? recipeId,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'video_url') String videoUrl,
      String message,
      List<int> comments,
      List<String> likes});
}

/// @nodoc
class _$PostCopyWithImpl<$Res> implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  final Post _value;
  // ignore: unused_field
  final $Res Function(Post) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? updatedAt = freezed,
    Object? ownerId = freezed,
    Object? recipeId = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? message = freezed,
    Object? comments = freezed,
    Object? likes = freezed,
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
      recipeId: recipeId == freezed
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: videoUrl == freezed
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      comments: comments == freezed
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<int>,
      likes: likes == freezed
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$$_PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$_PostCopyWith(_$_Post value, $Res Function(_$_Post) then) =
      __$$_PostCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? id,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'recipe_id') int? recipeId,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'video_url') String videoUrl,
      String message,
      List<int> comments,
      List<String> likes});
}

/// @nodoc
class __$$_PostCopyWithImpl<$Res> extends _$PostCopyWithImpl<$Res>
    implements _$$_PostCopyWith<$Res> {
  __$$_PostCopyWithImpl(_$_Post _value, $Res Function(_$_Post) _then)
      : super(_value, (v) => _then(v as _$_Post));

  @override
  _$_Post get _value => super._value as _$_Post;

  @override
  $Res call({
    Object? id = freezed,
    Object? updatedAt = freezed,
    Object? ownerId = freezed,
    Object? recipeId = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? message = freezed,
    Object? comments = freezed,
    Object? likes = freezed,
  }) {
    return _then(_$_Post(
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
      recipeId: recipeId == freezed
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: videoUrl == freezed
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      comments: comments == freezed
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<int>,
      likes: likes == freezed
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Post implements _Post {
  const _$_Post(
      {this.id,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'recipe_id') this.recipeId,
      @JsonKey(name: 'image_url') this.imageUrl = '',
      @JsonKey(name: 'video_url') this.videoUrl = '',
      required this.message,
      final List<int> comments = const [],
      final List<String> likes = const []})
      : _comments = comments,
        _likes = likes;

  factory _$_Post.fromJson(Map<String, dynamic> json) => _$$_PostFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  @JsonKey(name: 'recipe_id')
  final int? recipeId;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'video_url')
  final String videoUrl;
  @override
  final String message;
  final List<int> _comments;
  @override
  @JsonKey()
  List<int> get comments {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  final List<String> _likes;
  @override
  @JsonKey()
  List<String> get likes {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  @override
  String toString() {
    return 'Post(id: $id, updatedAt: $updatedAt, ownerId: $ownerId, recipeId: $recipeId, imageUrl: $imageUrl, videoUrl: $videoUrl, message: $message, comments: $comments, likes: $likes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Post &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality().equals(other.ownerId, ownerId) &&
            const DeepCollectionEquality().equals(other.recipeId, recipeId) &&
            const DeepCollectionEquality().equals(other.imageUrl, imageUrl) &&
            const DeepCollectionEquality().equals(other.videoUrl, videoUrl) &&
            const DeepCollectionEquality().equals(other.message, message) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            const DeepCollectionEquality().equals(other._likes, _likes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(updatedAt),
      const DeepCollectionEquality().hash(ownerId),
      const DeepCollectionEquality().hash(recipeId),
      const DeepCollectionEquality().hash(imageUrl),
      const DeepCollectionEquality().hash(videoUrl),
      const DeepCollectionEquality().hash(message),
      const DeepCollectionEquality().hash(_comments),
      const DeepCollectionEquality().hash(_likes));

  @JsonKey(ignore: true)
  @override
  _$$_PostCopyWith<_$_Post> get copyWith =>
      __$$_PostCopyWithImpl<_$_Post>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PostToJson(this);
  }
}

abstract class _Post implements Post {
  const factory _Post(
      {final int? id,
      @JsonKey(name: 'updated_at') required final String updatedAt,
      @JsonKey(name: 'owner_id') required final String ownerId,
      @JsonKey(name: 'recipe_id') final int? recipeId,
      @JsonKey(name: 'image_url') final String imageUrl,
      @JsonKey(name: 'video_url') final String videoUrl,
      required final String message,
      final List<int> comments,
      final List<String> likes}) = _$_Post;

  factory _Post.fromJson(Map<String, dynamic> json) = _$_Post.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  @JsonKey(name: 'recipe_id')
  int? get recipeId;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'video_url')
  String get videoUrl;
  @override
  String get message;
  @override
  List<int> get comments;
  @override
  List<String> get likes;
  @override
  @JsonKey(ignore: true)
  _$$_PostCopyWith<_$_Post> get copyWith => throw _privateConstructorUsedError;
}
