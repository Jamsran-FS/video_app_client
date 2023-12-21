// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
      like: json['like'] as int,
      comment: json['comment'] as int,
      view: json['view'] as int,
      share: json['share'] as int,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      participantID: json['participantID'] as String?,
      thumbnail: json['thumbnail'] as String?,
      videoURL: json['videoURL'] as String?,
      duration: json['duration'] as int?,
      watchedSec: json['watchedSec'] as int?,
      isFavorite: false,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'type': _$PostTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'images': instance.images,
      'participantID': instance.participantID,
      'thumbnail': instance.thumbnail,
      'videoURL': instance.videoURL,
      'duration': instance.duration,
      'watchedSec': instance.watchedSec,
      'like': instance.like,
      'comment': instance.comment,
      'view': instance.view,
      'share': instance.share,
    };

const _$PostTypeEnumMap = {
  PostType.video: 'video',
  PostType.image: 'image',
  PostType.text: 'text',
  PostType.podcast: 'podcast',
};
