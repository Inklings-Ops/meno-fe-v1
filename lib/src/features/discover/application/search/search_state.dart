part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required int page,
    required bool isLoading,
    required bool hasMore,
    required String? keyword,
    required List<Broadcast?> searchResults,
    required bool isSearchingMore,
    BroadcastException? exception,
  }) = _SearchState;

  factory SearchState.initial() {
    return const SearchState(
      page: 1,
      isLoading: false,
      hasMore: true,
      keyword: null,
      searchResults: [],
      isSearchingMore: false,
    );
  }
}
