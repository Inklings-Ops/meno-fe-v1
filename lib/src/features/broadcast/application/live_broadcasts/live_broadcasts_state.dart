part of 'live_broadcasts_bloc.dart';

@freezed
class LiveBroadcastsState with _$LiveBroadcastsState {
  const factory LiveBroadcastsState.empty() = _Empty;
  const factory LiveBroadcastsState.loading() = _Loading;
  const factory LiveBroadcastsState.success(
    List<Broadcast?> broadcasts,
  ) = _Success;
  const factory LiveBroadcastsState.failure() = _Failure;
}
