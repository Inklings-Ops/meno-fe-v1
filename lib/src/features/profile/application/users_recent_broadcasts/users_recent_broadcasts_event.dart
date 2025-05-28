part of 'users_recent_broadcasts_bloc.dart';

sealed class UsersRecentBroadcastsEvent with EquatableMixin {
  const UsersRecentBroadcastsEvent();

  @override
  List<Object?> get props => [];
}

final class UsersRecentBroadcastsFetchRequested
    extends UsersRecentBroadcastsEvent {
  const UsersRecentBroadcastsFetchRequested();
}

final class UsersRecentBroadcastsFetchMoreRequested
    extends UsersRecentBroadcastsEvent {
  const UsersRecentBroadcastsFetchMoreRequested();
}
