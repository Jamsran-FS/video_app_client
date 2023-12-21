import 'package:video_app/index.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final String id, title, text;
  final PostType type;
  final DateTime date;
  List<String>? images;
  String? participantID, thumbnail, videoURL;
  int? duration, watchedSec;
  int like, comment, view, share;
  bool isFavorite = false;

  Post({
    required this.id,
    required this.title,
    required this.text,
    required this.type,
    required this.date,
    required this.like,
    required this.comment,
    required this.view,
    required this.share,
    required this.isFavorite,
    this.images,
    this.participantID,
    this.thumbnail,
    this.videoURL,
    this.duration,
    this.watchedSec,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
