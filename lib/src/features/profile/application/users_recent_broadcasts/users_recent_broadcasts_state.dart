part of 'users_recent_broadcasts_bloc.dart';

@freezed
class UsersRecentBroadcastsState with _$UsersRecentBroadcastsState {
  const factory UsersRecentBroadcastsState.initial() =
      UsersRecentBroadcastsInitial;
  const factory UsersRecentBroadcastsState.empty() = UsersRecentBroadcastsEmpty;
  const factory UsersRecentBroadcastsState.loading() =
      UsersRecentBroadcastsLoading;
  const factory UsersRecentBroadcastsState.loaded(
    List<Broadcast?> broadcasts,
  ) = UsersRecentBroadcastsLoaded;
  const factory UsersRecentBroadcastsState.loadingMore(
    List<Broadcast?> broadcasts,
  ) = UsersRecentBroadcastsLoadingMore;
  const factory UsersRecentBroadcastsState.loadedLast(
    List<Broadcast?> broadcasts,
  ) = UsersRecentBroadcastsLoadedLast;
  const factory UsersRecentBroadcastsState.failure(
    BroadcastException exception,
  ) = UsersRecentBroadcastsFailure;
}
