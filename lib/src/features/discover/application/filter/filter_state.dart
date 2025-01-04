part of 'filter_bloc.dart';

@freezed
class FilterState with _$FilterState {
  const factory FilterState({
    required Filter filter,
    required Map<Filter, List<Broadcast?>> searchMap,
    required int page,
    required bool isLoading,
    required bool hasMore,
    BroadcastException? exception,
  }) = _SearchState;

  factory FilterState.initial() {
    return const FilterState(
      filter: Filter.all,
      searchMap: {Filter.all: []},
      page: 1,
      isLoading: false,
      hasMore: true,
    );
  }
}
