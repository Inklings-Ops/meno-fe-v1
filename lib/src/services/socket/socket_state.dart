part of 'socket_service.dart';

@freezed
class SocketState with _$SocketState {
  factory SocketState({
    required bool loading,
    required Broadcast liveBroadcast,
    required JoinBroadcastEntity joinedBroadcast,
    required List<Participant?> participants,
    required List<Broadcast?> liveBroadcasts,
    Participant? newParticipant,
    int? numberOfParticipants,
    int? numberOfLiveBroadcasts,
  }) = _SocketState;

  factory SocketState.initial({bool loading = false}) {
    return SocketState(
      loading: loading,
      liveBroadcast: Broadcast.empty(),
      joinedBroadcast: JoinBroadcastEntity.empty(),
      participants: [],
      liveBroadcasts: [],
      newParticipant: null,
      numberOfParticipants: 0,
      numberOfLiveBroadcasts: null,
    );
  }
}
