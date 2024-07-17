part of 'live_participants_bloc.dart';

@freezed
class LiveParticipantsState with _$LiveParticipantsState {
  const factory LiveParticipantsState({
    required Broadcast broadcast,
    required bool loading,
    required List<Participant?> participants,
    required int numberOfParticipants,
  }) = _LiveParticipantsState;

  factory LiveParticipantsState.initial() {
    return LiveParticipantsState(
      broadcast: Broadcast.empty(),
      participants: [],
      loading: false,
      numberOfParticipants: 0,
    );
  }
}
