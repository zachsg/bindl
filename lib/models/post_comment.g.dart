// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostComment _$$_PostCommentFromJson(Map<String, dynamic> json) =>
    _$_PostComment(
      comment: json['comment'] as String,
      ownerId: json['owner_id'] as String,
      updatedAt: json['updated_at'] as String,
      recipeId: json['recipe_id'] as String,
      imageUrl: json['image_url'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      comments:
          (json['comments'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              const [],
    );

Map<String, dynamic> _$$_PostCommentToJson(_$_PostComment instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'owner_id': instance.ownerId,
      'updated_at': instance.updatedAt,
      'recipe_id': instance.recipeId,
      'image_url': instance.imageUrl,
      'video_url': instance.videoUrl,
      'likes': instance.likes,
      'comments': instance.comments,
    };
