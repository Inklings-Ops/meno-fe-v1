part of 'recently_live_list_bloc.dart';

@freezed
class RecentlyLiveListEvent with _$RecentlyLiveListEvent {
  const factory RecentlyLiveListEvent.fetch() = _RLLFetchBroadcasts;
  const factory RecentlyLiveListEvent.fetchMore() = _RLLFetchMoreBroadcasts;
}
