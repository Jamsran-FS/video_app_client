part of 'participant_bloc.dart';

abstract class ParticipantEvent extends Equatable {
  const ParticipantEvent();
}

class ParticipantGetAll extends ParticipantEvent {
  final String userID;

  const ParticipantGetAll({required this.userID});

  @override
  List<Object> get props => [userID];
}
