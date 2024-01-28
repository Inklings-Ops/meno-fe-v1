part of 'live_participants_cubit.dart';

@freezed
class LiveParticipantsState with _$LiveParticipantsState {
  const factory LiveParticipantsState({
    required String? broadcastId,
    required bool loading,
    required List<Participant?> participants,
    required int numberOfParticipants,
  }) = _LiveParticipantsState;

  factory LiveParticipantsState.initial() {
    return const LiveParticipantsState(
      participants: [],
      loading: false,
      broadcastId: null,
      numberOfParticipants: 0,
    );
  }
}
