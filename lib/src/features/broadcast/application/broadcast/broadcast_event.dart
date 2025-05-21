part of 'broadcast_bloc.dart';

sealed class BroadcastEvent with EquatableMixin {
  const BroadcastEvent();

  @override
  List<Object?> get props => [];
}

final class BroadcastStartRequested extends BroadcastEvent {
  const BroadcastStartRequested({
    required this.title,
    required this.description,
    this.artwork,
    this.cohosts,
    this.timeZone,
  });

  final SingleLineString title;
  final BroadcastDescription description;
  final BroadcastArtwork? artwork;
  final List<String>? cohosts;
  final String? timeZone;

  @override
  List<Object?> get props => [title, description, artwork, cohosts, timeZone];
}

final class BroadcastEndRequested extends BroadcastEvent {
  const BroadcastEndRequested(this.broadcastId);
  final Uid<Broadcast> broadcastId;

  @override
  List<Object?> get props => [broadcastId];
}

final class BroadcastJoinRequested extends BroadcastEvent {
  const BroadcastJoinRequested(this.broadcastId);
  final Uid<Broadcast> broadcastId;

  @override
  List<Object?> get props => [broadcastId];
}

final class BroadcastLeaveRequested extends BroadcastEvent {
  const BroadcastLeaveRequested(this.broadcastId);
  final Uid<Broadcast> broadcastId;

  @override
  List<Object?> get props => [broadcastId];
}

final class BroadcastReconnectRequested extends BroadcastEvent {
  const BroadcastReconnectRequested({this.isStream = false});
  final bool isStream;

  @override
  List<Object?> get props => [isStream];
}

final class BroadcastResetRequested extends BroadcastEvent {
  const BroadcastResetRequested();
}
