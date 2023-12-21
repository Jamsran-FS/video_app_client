// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      postID: json['postID'] as String,
      comment: json['comment'] as String,
      commentedOn: DateTime.parse(json['commentedOn'] as String),
      user: UserAccount.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'postID': instance.postID,
      'comment': instance.comment,
      'commentedOn': instance.commentedOn.toIso8601String(),
      'user': instance.user.toJson(),
    };
