part of 'participant_bloc.dart';

abstract class ParticipantState extends Equatable {
  const ParticipantState();
}

class ParticipantInitial extends ParticipantState {
  const ParticipantInitial();

  @override
  List<Object?> get props => [];
}

class ParticipantLoading extends ParticipantState {
  const ParticipantLoading();

  @override
  List<Object?> get props => [];
}

class ParticipantSuccess extends ParticipantState {
  final List<Participant> data;

  const ParticipantSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class ParticipantFailure extends ParticipantState {
  final String message;

  const ParticipantFailure(this.message);

  @override
  List<Object?> get props => [message];
}
