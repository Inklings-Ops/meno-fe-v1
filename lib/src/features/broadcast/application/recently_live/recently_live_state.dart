part of 'recently_live_cubit.dart';

@freezed
class RecentlyLiveState with _$RecentlyLiveState {
  const factory RecentlyLiveState.loading() = _RLLLoadInProgress;
  const factory RecentlyLiveState.loadingMore(List<Broadcast?> broadcasts) = _RLLLoadMoreInProgress;
  const factory RecentlyLiveState.success(List<Broadcast?> broadcasts) = _RLLLoadSuccess;
  const factory RecentlyLiveState.successLast(List<Broadcast?> broadcasts) = _RLLLoadSuccessLast;
  const factory RecentlyLiveState.empty() = _RLLLoadEmpty;
  const factory RecentlyLiveState.failure() = _RLLLoadFailure;
}
