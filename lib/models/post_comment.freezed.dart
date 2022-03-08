// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'post_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PostComment _$PostCommentFromJson(Map<String, dynamic> json) {
  return _PostComment.fromJson(json);
}

/// @nodoc
class _$PostCommentTearOff {
  const _$PostCommentTearOff();

  _PostComment call(
      {required String comment,
      @JsonKey(name: 'owner_id') required String ownerId,
      @JsonKey(name: 'updated_at') required String updatedAt,
      @JsonKey(name: 'recipe_id') required String recipeId,
      @JsonKey(name: 'image_url') String imageUrl = '',
      @JsonKey(name: 'video_url') String videoUrl = '',
      List<String> likes = const [],
      List<int> comments = const []}) {
    return _PostComment(
      comment: comment,
      ownerId: ownerId,
      updatedAt: updatedAt,
      recipeId: recipeId,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      likes: likes,
      comments: comments,
    );
  }

  PostComment fromJson(Map<String, Object?> json) {
    return PostComment.fromJson(json);
  }
}

/// @nodoc
const $PostComment = _$PostCommentTearOff();

/// @nodoc
mixin _$PostComment {
  String get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_id')
  String get recipeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String get videoUrl => throw _privateConstructorUsedError;
  List<String> get likes => throw _privateConstructorUsedError;
  List<int> get comments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostCommentCopyWith<PostComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCommentCopyWith<$Res> {
  factory $PostCommentCopyWith(
          PostComment value, $Res Function(PostComment) then) =
      _$PostCommentCopyWithImpl<$Res>;
  $Res call(
      {String comment,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'recipe_id') String recipeId,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'video_url') String videoUrl,
      List<String> likes,
      List<int> comments});
}

/// @nodoc
class _$PostCommentCopyWithImpl<$Res> implements $PostCommentCopyWith<$Res> {
  _$PostCommentCopyWithImpl(this._value, this._then);

  final PostComment _value;
  // ignore: unused_field
  final $Res Function(PostComment) _then;

  @override
  $Res call({
    Object? comment = freezed,
    Object? ownerId = freezed,
    Object? updatedAt = freezed,
    Object? recipeId = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? likes = freezed,
    Object? comments = freezed,
  }) {
    return _then(_value.copyWith(
      comment: comment == freezed
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: ownerId == freezed
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      recipeId: recipeId == freezed
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: videoUrl == freezed
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      likes: likes == freezed
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comments: comments == freezed
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
abstract class _$PostCommentCopyWith<$Res>
    implements $PostCommentCopyWith<$Res> {
  factory _$PostCommentCopyWith(
          _PostComment value, $Res Function(_PostComment) then) =
      __$PostCommentCopyWithImpl<$Res>;
  @override
  $Res call(
      {String comment,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'recipe_id') String recipeId,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'video_url') String videoUrl,
      List<String> likes,
      List<int> comments});
}

/// @nodoc
class __$PostCommentCopyWithImpl<$Res> extends _$PostCommentCopyWithImpl<$Res>
    implements _$PostCommentCopyWith<$Res> {
  __$PostCommentCopyWithImpl(
      _PostComment _value, $Res Function(_PostComment) _then)
      : super(_value, (v) => _then(v as _PostComment));

  @override
  _PostComment get _value => super._value as _PostComment;

  @override
  $Res call({
    Object? comment = freezed,
    Object? ownerId = freezed,
    Object? updatedAt = freezed,
    Object? recipeId = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? likes = freezed,
    Object? comments = freezed,
  }) {
    return _then(_PostComment(
      comment: comment == freezed
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: ownerId == freezed
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      recipeId: recipeId == freezed
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: videoUrl == freezed
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      likes: likes == freezed
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comments: comments == freezed
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PostComment implements _PostComment {
  const _$_PostComment(
      {required this.comment,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'recipe_id') required this.recipeId,
      @JsonKey(name: 'image_url') this.imageUrl = '',
      @JsonKey(name: 'video_url') this.videoUrl = '',
      this.likes = const [],
      this.comments = const []});

  factory _$_PostComment.fromJson(Map<String, dynamic> json) =>
      _$$_PostCommentFromJson(json);

  @override
  final String comment;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'recipe_id')
  final String recipeId;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'video_url')
  final String videoUrl;
  @JsonKey()
  @override
  final List<String> likes;
  @JsonKey()
  @override
  final List<int> comments;

  @override
  String toString() {
    return 'PostComment(comment: $comment, ownerId: $ownerId, updatedAt: $updatedAt, recipeId: $recipeId, imageUrl: $imageUrl, videoUrl: $videoUrl, likes: $likes, comments: $comments)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostComment &&
            const DeepCollectionEquality().equals(other.comment, comment) &&
            const DeepCollectionEquality().equals(other.ownerId, ownerId) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality().equals(other.recipeId, recipeId) &&
            const DeepCollectionEquality().equals(other.imageUrl, imageUrl) &&
            const DeepCollectionEquality().equals(other.videoUrl, videoUrl) &&
            const DeepCollectionEquality().equals(other.likes, likes) &&
            const DeepCollectionEquality().equals(other.comments, comments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(comment),
      const DeepCollectionEquality().hash(ownerId),
      const DeepCollectionEquality().hash(updatedAt),
      const DeepCollectionEquality().hash(recipeId),
      const DeepCollectionEquality().hash(imageUrl),
      const DeepCollectionEquality().hash(videoUrl),
      const DeepCollectionEquality().hash(likes),
      const DeepCollectionEquality().hash(comments));

  @JsonKey(ignore: true)
  @override
  _$PostCommentCopyWith<_PostComment> get copyWith =>
      __$PostCommentCopyWithImpl<_PostComment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PostCommentToJson(this);
  }
}

abstract class _PostComment implements PostComment {
  const factory _PostComment(
      {required String comment,
      @JsonKey(name: 'owner_id') required String ownerId,
      @JsonKey(name: 'updated_at') required String updatedAt,
      @JsonKey(name: 'recipe_id') required String recipeId,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'video_url') String videoUrl,
      List<String> likes,
      List<int> comments}) = _$_PostComment;

  factory _PostComment.fromJson(Map<String, dynamic> json) =
      _$_PostComment.fromJson;

  @override
  String get comment;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'recipe_id')
  String get recipeId;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'video_url')
  String get videoUrl;
  @override
  List<String> get likes;
  @override
  List<int> get comments;
  @override
  @JsonKey(ignore: true)
  _$PostCommentCopyWith<_PostComment> get copyWith =>
      throw _privateConstructorUsedError;
}
