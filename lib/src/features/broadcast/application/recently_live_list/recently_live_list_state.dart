part of 'recently_live_list_bloc.dart';

@freezed
class RecentlyLiveListState with _$RecentlyLiveListState {
  const factory RecentlyLiveListState.loading() = _RLLLoadInProgress;
  const factory RecentlyLiveListState.loadingMore(List<Broadcast?> broadcasts) = _RLLLoadMoreInProgress;
  const factory RecentlyLiveListState.success(List<Broadcast?> broadcasts) = _RLLLoadSuccess;
  const factory RecentlyLiveListState.successLast(List<Broadcast?> broadcasts) = _RLLLoadSuccessLast;
  const factory RecentlyLiveListState.empty() = _RLLLoadEmpty;
  const factory RecentlyLiveListState.failure() = _RLLLoadFailure;
}
