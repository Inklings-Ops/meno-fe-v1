part of 'users_all_broadcasts_bloc.dart';

@freezed
class UsersAllBroadcastsEvent with _$UsersAllBroadcastsEvent {
  const factory UsersAllBroadcastsEvent.getBroadcasts() = GetUsersBroadcasts;
  const factory UsersAllBroadcastsEvent.getMoreBroadcasts() =
      GetMoreUsersBroadcasts;
}
