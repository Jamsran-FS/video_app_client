import 'package:video_app/index.dart';

part 'watch_later.g.dart';

@JsonSerializable()
class WatchLater {
  final String id, userID, postID;
  int watchedSec;

  WatchLater({
    required this.id,
    required this.userID,
    required this.postID,
    required this.watchedSec,
  });

  factory WatchLater.fromJson(Map<String, dynamic> json) => _$WatchLaterFromJson(json);
  Map<String, dynamic> toJson() => _$WatchLaterToJson(this);
}