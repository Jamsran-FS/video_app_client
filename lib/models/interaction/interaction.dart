import 'package:video_app/index.dart';

part 'interaction.g.dart';

@JsonSerializable()
class Interaction {
  final String id, userID;
  final InteractionType type;
  String? postID, participantID;

  Interaction({
    required this.id,
    required this.userID,
    required this.type,
    this.postID,
    this.participantID,
  });

  factory Interaction.fromJson(Map<String, dynamic> json) => _$InteractionFromJson(json);
  Map<String, dynamic> toJson() => _$InteractionToJson(this);
}
