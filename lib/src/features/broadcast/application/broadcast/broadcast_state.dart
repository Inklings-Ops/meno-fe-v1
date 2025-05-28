part of 'broadcast_bloc.dart';

enum LiveBroadcastStatus {
  initial,
  loading,
  started,
  joined,
  ended,
  left,
  failure,
  reconnecting,
  offAir,
}

extension LiveBroadcastStatusX on LiveBroadcastStatus {
  bool get isInitial => this == LiveBroadcastStatus.initial;
  bool get isLoading => this == LiveBroadcastStatus.loading;
  bool get isStarted => this == LiveBroadcastStatus.started;
  bool get isEnded => this == LiveBroadcastStatus.ended;
  bool get isLeft => this == LiveBroadcastStatus.left;
  bool get isJoined => this == LiveBroadcastStatus.joined;
  bool get isFailure => this == LiveBroadcastStatus.failure;
  bool get isReconnecting => this == LiveBroadcastStatus.reconnecting;
  bool get isOffAir => this == LiveBroadcastStatus.offAir;
}

final class BroadcastState with EquatableMixin {
  BroadcastState({
    this.status = LiveBroadcastStatus.initial,
    this.hostDisconnected = false,
    this.isReconnect = false,
    this.exception,
    this.isStream = false,
    this.isMicrophoneEnabled = false,
    Broadcast? broadcast,
  }) : broadcast = broadcast ?? Broadcast.empty;

  final Broadcast broadcast;
  final LiveBroadcastStatus status;
  final bool hostDisconnected;
  final bool isReconnect;
  final BroadcastException? exception;
  final bool isStream;
  final bool isMicrophoneEnabled;

  BroadcastState copyWith({
    Broadcast? broadcast,
    LiveBroadcastStatus? status,
    bool? hostDisconnected,
    bool? isReconnect,
    BroadcastException? exception,
    bool? isStream,
    bool? isMicrophoneEnabled,
  }) {
    return BroadcastState(
      broadcast: broadcast ?? this.broadcast,
      status: status ?? this.status,
      hostDisconnected: hostDisconnected ?? this.hostDisconnected,
      isReconnect: isReconnect ?? this.isReconnect,
      exception: exception ?? this.exception,
      isStream: isStream ?? this.isStream,
      isMicrophoneEnabled: isMicrophoneEnabled ?? this.isMicrophoneEnabled,
    );
  }

  @override
  List<Object?> get props => [
        broadcast,
        status,
        hostDisconnected,
        isReconnect,
        isMicrophoneEnabled,
      ];
}
