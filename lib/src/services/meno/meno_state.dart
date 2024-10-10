part of 'meno_bloc.dart';

/// Base type for all [Broadcast] events.
abstract class MBroadcastEvent implements MenoState {}

/// Base type for all Notifications events.
abstract class MNotificationEvent implements MenoState {}

/// Base type for all [Chat] events.
abstract class MChatEvent implements MenoState {}

abstract class MSignalEvent implements MenoState {}

@freezed
class MenoState with _$MenoState {
  /// When a broadcast is live broadcasting
  /// Emitted when the [LiveKitService] [RoomReconnectedEvent] and
  /// [LocalTrackPublishedEvent] events are emitted
  @Implements<MSignalEvent>()
  const factory MenoState.live() = MLive;

  /// When a broadcast is trying to reconnect
  /// Emitted when the [LiveKitService] [RoomReconnectingEvent] is emitted
  @Implements<MSignalEvent>()
  const factory MenoState.reconnecting() = MReconnecting;

  /// When a broadcast is streaming a live broadcast
  /// Emitted when the [LiveKitService] [RoomDisconnectedEvent] is emitted
  @Implements<MSignalEvent>()
  const factory MenoState.streaming() = MStreaming;

  /// When a broadcast is disconnected
  /// Emitted when the [LiveKitService] [RoomDisconnectedEvent] is emitted
  @Implements<MSignalEvent>()
  const factory MenoState.offAir() = MOffAir;

  /// When a live [Broadcast] has just been ended by a [Participant].
  /// Emitted by `endedBroadcast` websocket event via [SocketService]
  @Implements<MBroadcastEvent>()
  const factory MenoState.endedBroadcast(
    EndedBroadcastData data,
  ) = MEndedBroadcast;

  /// When a [Participant] leaves a live [Broadcast] that the [Participant] has
  /// joined.
  ///
  /// Emitted by `leaveBroadcast` websocket event via [SocketService]
  @Implements<MBroadcastEvent>()
  const factory MenoState.leaveBroadcast() = MLeaveBroadcast;

  @Implements<MBroadcastEvent>()
  const factory MenoState.leftBroadcast(
    BroadcastParticipant participant,
  ) = MLeftBroadcast;
}
