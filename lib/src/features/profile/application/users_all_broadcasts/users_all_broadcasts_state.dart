part of 'users_all_broadcasts_bloc.dart';

@freezed
class UsersAllBroadcastsState with _$UsersAllBroadcastsState {
  const factory UsersAllBroadcastsState.initial() = UsersAllBroadcastsInitial;
  const factory UsersAllBroadcastsState.empty() = UsersAllBroadcastsEmpty;
  const factory UsersAllBroadcastsState.loading() = UsersAllBroadcastsLoading;
  const factory UsersAllBroadcastsState.loaded(
    List<Broadcast?> broadcasts,
  ) = UsersAllBroadcastsLoaded;
  const factory UsersAllBroadcastsState.loadingMore(
    List<Broadcast?> broadcasts,
  ) =
      UsersAllBroadcastsLoadingMore;
  const factory UsersAllBroadcastsState.loadedLast(
    List<Broadcast?> broadcasts,
  ) = UsersAllBroadcastsLoadedLast;
  const factory UsersAllBroadcastsState.failure(BroadcastException exception) =
      UsersAllBroadcastsFailure;
}
