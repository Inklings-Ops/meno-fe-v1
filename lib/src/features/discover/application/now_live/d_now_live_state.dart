part of 'd_now_live_cubit.dart';

@freezed
class DNowLiveState with _$DNowLiveState {
  const factory DNowLiveState({
    required List<Broadcast?> broadcasts,
    required int page,
    required bool isLoading,
    required bool hasMore,
    required bool hasError,
  }) = _DNowLiveState;

  factory DNowLiveState.initial() {
    return const DNowLiveState(
      broadcasts: [],
      page: 1,
      isLoading: false,
      hasMore: true,
      hasError: false,
    );
  }
}
