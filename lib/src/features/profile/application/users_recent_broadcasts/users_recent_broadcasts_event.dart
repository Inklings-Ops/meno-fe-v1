part of 'users_recent_broadcasts_bloc.dart';

@freezed
class UsersRecentBroadcastsEvent with _$UsersRecentBroadcastsEvent {
  const factory UsersRecentBroadcastsEvent.getBroadcasts() =
      GetUsersRecentBroadcasts;
  const factory UsersRecentBroadcastsEvent.getMoreBroadcasts() =
      GetMoreUsersRecentBroadcasts;
}
