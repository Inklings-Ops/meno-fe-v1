part of 'd_recently_live_cubit.dart';

@freezed
class DRecentlyLiveState with _$DRecentlyLiveState {
const factory DRecentlyLiveState({
    required List<Broadcast?> broadcasts,
    required int page,
    required bool isLoading,
    required bool hasMore,
    required bool hasError,
  }) = _DNowLiveState;

  factory DRecentlyLiveState.initial() {
    return const DRecentlyLiveState(
      broadcasts: [],
      page: 1,
      isLoading: false,
      hasMore: true,
      hasError: false,
    );
  }}
