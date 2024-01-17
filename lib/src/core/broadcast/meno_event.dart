import 'package:freezed_annotation/freezed_annotation.dart';

import '../../features/broadcast/domain/domain.dart';

part 'meno_event.freezed.dart';

/// Base type for all [Broadcast] events.
abstract class BroadcastEvent implements MenoEvent {}

/// Base type for all [Notification] events.
abstract class NotificationEvent implements MenoEvent {}

/// Base type for all [Chat] events.
abstract class ChatEvent implements MenoEvent {}

abstract class MSignalEvent implements MenoEvent {}

/// Base type for all Meno events.
@freezed
sealed class MenoEvent with _$MenoEvent {
  /// When a broadcast is live broadcasting
  /// Emitted when the [LiveKitService] [RoomReconnectedEvent] and
  /// [LocalTrackPublishedEvent] events are emitted
  @Implements<MSignalEvent>()
  const factory MenoEvent.isLive() = IsLiveEvent;

  /// When a broadcast is trying to reconnect
  /// Emitted when the [LiveKitService] [RoomReconnectingEvent] is emitted
  @Implements<MSignalEvent>()
  const factory MenoEvent.isReconnecting() = IsReconnectingEvent;

  /// When a broadcast is streaming a live broadcast
  /// Emitted when the [LiveKitService] [RoomDisconnectedEvent] is emitted
  @Implements<MSignalEvent>()
  const factory MenoEvent.isStreaming() = IsStreamingEvent;

  /// When a broadcast is disconnected
  /// Emitted when the [LiveKitService] [RoomDisconnectedEvent] is emitted
  @Implements<MSignalEvent>()
  const factory MenoEvent.isOffAir() = IsOffAirEvent;

  /// When a live [Broadcast] has just been ended by a [Participant].
  /// Emitted by [endedBroadcast] websocket event via [SocketService]
  @Implements<BroadcastEvent>()
  const factory MenoEvent.endedBroadcast({
    String? reason,
  }) = EndedBroadcastEvent;

  /// When a [Participant] leaves a live [Broadcast] that the [Participant] has joined.
  /// Emitted by [leaveBroadcast] websocket event via [SocketService]
  @Implements<BroadcastEvent>()
  const factory MenoEvent.leaveBroadcast() = LeaveBroadcastEvent;
}
