import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_comment.freezed.dart';
part 'post_comment.g.dart';

@Freezed()
class PostComment with _$PostComment {
  const factory PostComment({
    required String comment,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'recipe_id') required String recipeId,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'video_url') @Default('') String videoUrl,
    @Default([]) List<String> likes,
    @Default([]) List<int> comments,
  }) = _PostComment;

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);
}
