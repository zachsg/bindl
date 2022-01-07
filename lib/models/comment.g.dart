// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      authorID: json['authorID'] as String,
      authorName: json['authorName'] as String,
      date: json['date'] as String,
      message: json['message'] as String,
      reactions: (json['reactions'] as List<dynamic>)
          .map((e) => $enumDecode(_$ReactionEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'authorID': instance.authorID,
      'authorName': instance.authorName,
      'date': instance.date,
      'message': instance.message,
      'reactions': instance.reactions.map((e) => _$ReactionEnumMap[e]).toList(),
    };

const _$ReactionEnumMap = {
  Reaction.adhore: 'adhore',
  Reaction.like: 'like',
};
