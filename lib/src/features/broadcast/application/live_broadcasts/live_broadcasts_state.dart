part of 'live_broadcasts_bloc.dart';

@freezed
class LiveBroadcastsState with _$LiveBroadcastsState {
  const factory LiveBroadcastsState.empty() = LiveBroadcastsEmpty;
  const factory LiveBroadcastsState.loading() = LoadingLiveBroadcasts;
  const factory LiveBroadcastsState.loadingMore(
    List<Broadcast?> broadcasts,
  ) = LoadingMoreLiveBroadcasts;
  const factory LiveBroadcastsState.loaded(
    List<Broadcast?> broadcasts,
  ) = LiveBroadcastsLoaded;
  const factory LiveBroadcastsState.loadedLast(
    List<Broadcast?> broadcasts,
  ) = LiveBroadcastsLoadedLast;
  const factory LiveBroadcastsState.failure() = LiveBroadcastFailure;
}
