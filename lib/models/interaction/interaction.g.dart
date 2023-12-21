// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Interaction _$InteractionFromJson(Map<String, dynamic> json) => Interaction(
      id: json['id'] as String,
      userID: json['userID'] as String,
      type: $enumDecode(_$InteractionTypeEnumMap, json['type']),
      postID: json['postID'] as String?,
      participantID: json['participantID'] as String?,
    );

Map<String, dynamic> _$InteractionToJson(Interaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'type': _$InteractionTypeEnumMap[instance.type]!,
      'postID': instance.postID,
      'participantID': instance.participantID,
    };

const _$InteractionTypeEnumMap = {
  InteractionType.likePost: 'likePost',
  InteractionType.viewPost: 'viewPost',
  InteractionType.sharePost: 'sharePost',
  InteractionType.likeParticipant: 'likeParticipant',
};
