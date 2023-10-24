part of 'socket_service.dart';

@freezed
class SocketState with _$SocketState {
  factory SocketState({
    required bool isLive,
    required Broadcast liveBroadcast,
    required List<Participant?> participants,
    required List<Broadcast?> liveBroadcasts,
    Participant? newParticipant,
    int? numberOfParticipants,
    int? numberOfLiveBroadcasts,
  }) = _SocketState;

  factory SocketState.initial() {
    return SocketState(
      isLive: false,
      liveBroadcast: Broadcast.empty(),
      participants: [],
      liveBroadcasts: [],
      newParticipant: null,
      numberOfParticipants: 0,
      numberOfLiveBroadcasts: null,
    );
  }
}
