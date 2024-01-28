part of 'recently_live_cubit.dart';

@freezed
class RecentlyLiveEvent with _$RecentlyLiveEvent {
  const factory RecentlyLiveEvent.fetch() = _RLLFetchBroadcasts;
  const factory RecentlyLiveEvent.fetchMore() = _RLLFetchMoreBroadcasts;
}
