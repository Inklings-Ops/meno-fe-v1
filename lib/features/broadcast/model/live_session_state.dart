sealed class LiveSessionState {
  const LiveSessionState();

  const factory LiveSessionState.initializing() = LiveSessionInitializing;

  const factory LiveSessionState.broadcasting() = LiveSessionBroadcasting;

  const factory LiveSessionState.streaming() = LiveSessionStreaming;

  const factory LiveSessionState.hostDisconnected() =
      LiveSessionHostDisconnected;

  const factory LiveSessionState.ended() = LiveSessionEnded;

  const factory LiveSessionState.error(String message) = LiveSessionError;
}

final class LiveSessionInitializing extends LiveSessionState {
  const LiveSessionInitializing();
}

final class LiveSessionBroadcasting extends LiveSessionState {
  const LiveSessionBroadcasting();
}

final class LiveSessionStreaming extends LiveSessionState {
  const LiveSessionStreaming();
}

final class LiveSessionHostDisconnected extends LiveSessionState {
  const LiveSessionHostDisconnected();
}

final class LiveSessionEnded extends LiveSessionState {
  const LiveSessionEnded();
}

final class LiveSessionError extends LiveSessionState {
  const LiveSessionError(this.message);

  final String message;
}

/// Global connection status
enum LiveStatus {
  initializing,
  connecting,
  live,
  reconnecting,
  disconnected,
  hostDisconnected,
  disconnecting,
  offAir,
}

/// Extension for user-friendly labels
extension LiveStatusX on LiveStatus {
  String get name {
    return switch (this) {
      .initializing => 'Initializing...',
      .connecting => 'Connecting...',
      .live => 'Live',
      .reconnecting => 'Reconnecting...',
      .disconnected => 'Disconnected',
      .hostDisconnected => 'Host Disconnected',
      .disconnecting => 'Ending...',
      .offAir => 'Off Air',
    };
  }

  String get hostTitle => switch (this) {
    .live => 'Now Live',
    .reconnecting => 'Reconnecting',
    _ => '',
  };

  String get participantTitle => switch (this) {
    .live => 'Now Streaming',
    .reconnecting => 'Reconnecting',
    _ => '',
  };

  bool get isInitializing => this == .initializing || this == .connecting;

  bool get isActive => this == .live;

  bool get showReconnecting => this == .reconnecting || this == .connecting;

  bool get isNotLive => this != .live || this != .reconnecting;
}
