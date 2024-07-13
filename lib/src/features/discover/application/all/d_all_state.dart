part of 'd_all_cubit.dart';

@freezed
class DAllState with _$DAllState {
  const factory DAllState({
    required List<Broadcast?> nowLive,
    required List<Broadcast?> recentlyLive,
    required bool isNowLiveLoading,
    required bool isRecentlyLiveLoading,
  }) = _DAllState;
  factory DAllState.initial() {
    return const DAllState(
      nowLive: [],
      recentlyLive: [],
      isNowLiveLoading: false,
      isRecentlyLiveLoading: false,
    );
  }
}
