// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Post _$$_PostFromJson(Map<String, dynamic> json) => _$_Post(
      id: json['id'] as int?,
      updatedAt: json['updated_at'] as String,
      ownerId: json['owner_id'] as String,
      recipeId: json['recipe_id'] as int?,
      imageUrl: json['image_url'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      message: json['message'] as String,
      comments:
          (json['comments'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              const [],
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$_PostToJson(_$_Post instance) => <String, dynamic>{
      'id': instance.id,
      'updated_at': instance.updatedAt,
      'owner_id': instance.ownerId,
      'recipe_id': instance.recipeId,
      'image_url': instance.imageUrl,
      'video_url': instance.videoUrl,
      'message': instance.message,
      'comments': instance.comments,
      'likes': instance.likes,
    };
