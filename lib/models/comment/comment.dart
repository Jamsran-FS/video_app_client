import 'package:video_app/index.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String id, postID, comment;
  final DateTime commentedOn;
  final UserAccount user;

  Comment({
    required this.id,
    required this.postID,
    required this.comment,
    required this.commentedOn,
    required this.user
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
