import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    int? id,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'recipe_id') int? recipeId,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'video_url') @Default('') String videoUrl,
    required String message,
    @Default([]) List<int> comments,
    @Default([]) List<String> likes,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
