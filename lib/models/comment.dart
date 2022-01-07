import 'package:bodai/models/reaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String authorID;
  final String authorName;
  final String date;
  final String message;
  final List<Reaction> reactions;

  Comment({
    required this.authorID,
    required this.authorName,
    required this.date,
    required this.message,
    required this.reactions,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  Comment copyWith({
    String? authorID,
    String? authorName,
    String? date,
    String? message,
    List<Reaction>? reactions,
  }) =>
      Comment(
        authorID: authorID ?? this.authorID,
        authorName: authorName ?? this.authorName,
        date: date ?? this.date,
        message: message ?? this.message,
        reactions: reactions ?? this.reactions,
      );
}
