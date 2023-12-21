import 'dart:developer';
import 'package:video_app/index.dart';

part 'participant_event.dart';
part 'participant_state.dart';

class ParticipantBloc extends Bloc<ParticipantEvent, ParticipantState> {
  ParticipantBloc() : super(const ParticipantInitial()) {
    on<ParticipantGetAll>((event, emit) async {
      emit(const ParticipantLoading());
      try {
        final data =
            await ParticipantRepository().getAll(event.props.first.toString());
        emit(ParticipantSuccess(data));
      } catch (e) {
        log(e.toString());
        emit(ParticipantFailure(e.toString()));
      }
    });
  }
}
