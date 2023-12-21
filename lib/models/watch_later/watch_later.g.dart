// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_later.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchLater _$WatchLaterFromJson(Map<String, dynamic> json) => WatchLater(
      id: json['id'] as String,
      userID: json['userID'] as String,
      postID: json['postID'] as String,
      watchedSec: json['watchedSec'] as int,
    );

Map<String, dynamic> _$WatchLaterToJson(WatchLater instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'postID': instance.postID,
      'watchedSec': instance.watchedSec,
    };
