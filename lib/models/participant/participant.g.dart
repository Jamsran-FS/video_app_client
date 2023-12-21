// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      photo: json['photo'] as String,
      intro: json['intro'] as String,
      famousVideoThumb: json['famousVideoThumb'] as String?,
      videoCount: json['videoCount'] as int?,
      likeCount: json['likeCount'] as int?,
      isFavorite: false,
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'intro': instance.intro,
      'photo': instance.photo,
      'famousVideoThumb': instance.famousVideoThumb,
      'videoCount': instance.videoCount,
      'likeCount': instance.likeCount,
    };
