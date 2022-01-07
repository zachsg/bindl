import 'package:bodai/models/reaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String author;
  final String message;
  final List<Reaction> reactions;

  Comment({
    required this.author,
    required this.message,
    required this.reactions,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  Comment copyWith({
    String? author,
    String? message,
    List<Reaction>? reactions,
  }) =>
      Comment(
        author: author ?? this.author,
        message: message ?? this.message,
        reactions: reactions ?? this.reactions,
      );
}
