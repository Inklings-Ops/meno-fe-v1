part of 'participants_bloc.dart';

sealed class ParticipantsEvent with EquatableMixin {
  const ParticipantsEvent();
  @override
  List<Object?> get props => [];
}

final class ParticipantsFetchRequested extends ParticipantsEvent {
  const ParticipantsFetchRequested(this.broadcastId);
  final ID broadcastId;

  @override
  List<Object?> get props => [broadcastId];
}

final class ParticipantsReloadRequested extends ParticipantsEvent {
  const ParticipantsReloadRequested(this.broadcastId);
  final ID broadcastId;

  @override
  List<Object?> get props => [broadcastId];
}

final class ParticipantsFetchAllRequested extends ParticipantsEvent {
  const ParticipantsFetchAllRequested(this.broadcastId);
  final ID broadcastId;

  @override
  List<Object?> get props => [broadcastId];
}

final class _ParticipantJoinedSubscribed extends ParticipantsEvent {
  const _ParticipantJoinedSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class _ParticipantLeftSubscribed extends ParticipantsEvent {
  const _ParticipantLeftSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class ParticipantsResetRequested extends ParticipantsEvent {
  const ParticipantsResetRequested();
}
