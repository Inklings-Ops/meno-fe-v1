part of 'users_all_broadcasts_bloc.dart';

sealed class UsersAllBroadcastsEvent with EquatableMixin {
  const UsersAllBroadcastsEvent();

  @override
  List<Object?> get props => [];
}

final class UsersAllBroadcastsFetchRequested extends UsersAllBroadcastsEvent {
  const UsersAllBroadcastsFetchRequested();
}

final class UsersAllBroadcastsFetchMoreRequested
    extends UsersAllBroadcastsEvent {
  const UsersAllBroadcastsFetchMoreRequested();
}
