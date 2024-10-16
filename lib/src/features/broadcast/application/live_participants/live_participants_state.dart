part of 'live_participants_bloc.dart';

@freezed
class LiveParticipantsState with _$LiveParticipantsState {
  const factory LiveParticipantsState({
    required Broadcast broadcast,
    required bool loading,
    required List<BroadcastParticipant> liveParticipants,
    required int numberOfLiveParticipants,
    required List<BroadcastParticipant> totalParticipants,
    required int numberOfTotalParticipants,
  }) = _LiveParticipantsState;

  factory LiveParticipantsState.initial() {
    return LiveParticipantsState(
      broadcast: Broadcast.empty(),
      loading: false,
      liveParticipants: [],
      numberOfLiveParticipants: 0,
      totalParticipants: [],
      numberOfTotalParticipants: 0,
    );
  }
}
